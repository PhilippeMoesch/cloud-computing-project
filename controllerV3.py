import psutil
import docker
import time
import os
import sys
# sudo docker container stop run_canneal
# sudo docker container stop run_freqmine
# sudo docker system prune -a

#RUNNING = 'running'
#container = DOCKER_CLIENT.containers.get(container_name)
#container_state = container.attrs['State']
#container_is_running = container_state['Status'] == RUNNING


fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [canneal, ferret, blackscholes, freqmine, fft, dedup]
parsec_names = ["canneal", "ferret", "blackscholes", "freqmine", "splash2x.fft", "dedup"]
#parsec_start = [0, 0, 0, 0, 0, 0]
#parsec_end = [0, 0, 0, 0, 0, 0]

# we run the first three images always on cores 2 and 3
# the last three images are run on core 1, and paused/unpaused when needed 

client = docker.from_env()

# pull all images
for container in parsec_jobs:
    client.images.pull(container)
    print("pulled image of " + container)

#create an image for all jobs
indexJob = 0
for job in parsec_jobs:
    name = parsec_names[indexJob]
    indexJob = indexJob + 1
    temp = client.containers.create(job, name=name)
    print("created jobs for " + name)

# current number of CPU cores memcached uses
cpuNum = 2
# process id of memcached
pid = sys.argv[1]
indexContainers2and3 = 0
indexContainers1 = 4

# let memcached run on cores 0 and 1
os.system('sudo taskset -a -cp 0-1 ' + pid)
   
jobCommand = lambda index, t : "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[index] + " -i native -n " + str(t) + "'"

# start freqmine job
#jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 2'"
jobName = "run_" + parsec_names[indexContainers2and3]
currentContainer = client.containers.run(parsec_jobs[0], command=jobCommand(indexContainers2and3,2), cpuset_cpus="2-3", detach=True, remove=False, name=jobName)
runningContainer2and3 = currentContainer
print(time.time())
print(jobName + " started")

# start canneal job
# jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 1'"
jobName = "run_" + parsec_names[indexContainers1]
currentContainer = client.containers.run(parsec_jobs[4], command=jobCommand(indexContainers1,1), cpuset_cpus="1", detach=True, remove=False, name=jobName)
currentContainer.pause()
runningContainer1 = currentContainer
print(time.time())
print(jobName + " started")
#skip = False
done1 = False
done2 = False

while((not done1) or (not done2)):
    # get CPU values
    cpu_usages = psutil.cpu_percent(percpu=True)

    # check whether the job running on cores 2 and 3 exited by now
    # start a new one, if this is the case
    if (not done1):
        myJobName = runningContainer2and3.name
        myContainer = client.containers.get(myJobName)
        if(myContainer.status == "exited"):
            print(time.time())
            print(myContainer.name + " done")
            if (indexContainers2and3 == 3):
                #all jobs done
                done1 = True
                continue
                  
            indexContainers2and3 = indexContainers2and3 + 1
            #if ((indexContainers2and3 == 1) and skip):
            #    continue
            #newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexContainers2and3] + " -i native -n 2'"
            newJobName = "run_" + parsec_names[indexContainers2and3]
            stringCpuSet = "2-3"
            newContainer = client.containers.run(parsec_jobs[indexContainers2and3], command=jobCommand(indexContainers2and3,2), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
            runningContainer2and3 = newContainer
            print(newJobName + " started")
            #if (indexContainers2and3 == 1):
            #    skip = True 

    # check whether the job running on core 1 exited by now
    # start a new one, if this is the case
    if (not done2):
        myJobName = runningContainer1.name
        myContainer = client.containers.get(myJobName)
        if(myContainer.status == "exited"):
            print(time.time())
            print(myContainer.name + " done")
            if (indexContainers1 == 5):
                #all jobs done
                done2 = True
                continue
            
            indexContainers1 = indexContainers1 + 1
            #if ((indexContainers2and3 == 1) and skip):
            #    continue
            #newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexContainers1 + 3] + " -i native -n 1'"
            newJobName = "run_" + parsec_names[indexContainers1]
            stringCpuSet = "1"
            newContainer = client.containers.run(parsec_jobs[indexContainers1], command=jobCommand(indexContainers1, 1), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
            runningContainer1 = newContainer
            print(newJobName + " started")
            #if (indexContainers2and3 == 1):
            #    skip = True 

            # check whether it's necessary to adjust the number of CPUs memcached has available
            #print("cpu0 : " + str(cpu_usages[0]) + "\n" + 
            #      "cpu1 : " + str(cpu_usages[1]) + "\n" + 
            #      "cpu2 : " + str(cpu_usages[2]) + "\n" + 
            #      "cpu3 : " + str(cpu_usages[3]))
          
        if (cpuNum == 1 and cpu_usages[0] >= 85):
            # increase number of CPUs, pause job running on core 1
            print(time.time())
            #print ("status of " + runningContainer1.name + " : " + runningContainer1.status)
            if (indexContainers1 < 5):
                print("pausing " + runningContainer1.name)
                runningContainer1.pause()
            #print ("status of " + runningContainer1.name + " : " + runningContainer1.status)
            os.system('sudo taskset -a -cp 0-1 ' + pid)
            cpuNum = 2
        elif(cpuNum == 2 and cpu_usages[0] <= 40):
            # decrease number of CPUs, unpause job running on core 1
            print(time.time())
            #print ("status of " + runningContainer1.name + " : " + runningContainer1.status)
            if (indexContainers1 < 5):
                print("un-pause " + runningContainer1.name)
                runningContainer1.unpause()
            #print ("status of " + runningContainer1.name + " : " + runningContainer1.status)
            os.system('sudo taskset -a -cp 0 ' + pid)
            cpuNum = 1
    else:
        if(cpuNum == 1 and cpu_usages[0] >= 85):
            print(time.time())
            os.system('sudo taskset -a -cp 0-1 ' + pid)
            runningContainer2and3.update(cpuset_cpus="2-3")
            cpuNum = 2
        elif(cpuNum == 2 and cpu_usages[0] <= 40):
            print(time.time())
            os.system('sudo taskset -a -cp 0 ' + pid)
            runningContainer2and3.update(cpuset_cpus="1-3")
            cpuNum = 1
        
        
        
    time.sleep(1)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
