import psutil
import docker
import time
import os
import sys
import math

fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [canneal, ferret, blackscholes, freqmine, fft, dedup]
parsec_names = ["canneal", "ferret", "blackscholes", "freqmine", "splash2x.fft", "dedup"]

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

f = open('ret.txt', 'w')

# let memcached run on cores 0 and 1
os.system('sudo taskset -a -cp 0-1 ' + pid)
   
jobCommand = lambda index, t : "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[index] + " -i native -n " + str(t) + "'"

jobName = "run_" + parsec_names[indexContainers2and3]
currentContainer = client.containers.run(parsec_jobs[0], command=jobCommand(indexContainers2and3,3), cpuset_cpus="2-3", detach=True, remove=False, name=jobName)
runningContainer2and3 = currentContainer
print(math.floor(time.time()), file=f)
print(" " + jobName + " started" + "\n", file=f)

jobName = "run_" + parsec_names[indexContainers1]
currentContainer = client.containers.run(parsec_jobs[4], command=jobCommand(indexContainers1,1), cpuset_cpus="1", detach=True, remove=False, name=jobName)
currentContainer.pause()
runningContainer1 = currentContainer
print(math.floor(time.time()), file=f)
print(" " + jobName + " started" + "\n", file=f)
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
            print(math.floor(time.time()), file=f)
            print(" " + myContainer.name + " done, ", file=f)
            if (indexContainers2and3 == 3):
                #all jobs done
                done1 = True
                continue
                  
            indexContainers2and3 = indexContainers2and3 + 1
            newJobName = "run_" + parsec_names[indexContainers2and3]
            stringCpuSet = "2-3"
            newContainer = client.containers.run(parsec_jobs[indexContainers2and3], command=jobCommand(indexContainers2and3,3), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
            runningContainer2and3 = newContainer
            print(" " + newJobName + " started" + "\n", file=f)

    # check whether the job running on core 1 exited by now
    # start a new one, if this is the case
    if (not done2):
        myJobName = runningContainer1.name
        myContainer = client.containers.get(myJobName)
        if(myContainer.status == "exited"):
            print(math.floor(time.time()), file=f)
            print(" " + myContainer.name + " done, ", file=f)
            if (indexContainers1 == 5):
                #all jobs done
                done2 = True
                continue
            
            indexContainers1 = indexContainers1 + 1
            newJobName = "run_" + parsec_names[indexContainers1]
            stringCpuSet = "1"
            newContainer = client.containers.run(parsec_jobs[indexContainers1], command=jobCommand(indexContainers1, 1), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
            runningContainer1 = newContainer
            print(" " + newJobName + " started" + "\n", file=f)
          
        if (cpuNum == 1 and cpu_usages[0] >= 85):
            # increase number of CPUs, pause job running on core 1
            print(math.floor(time.time()), file=f)
            if (indexContainers1 < 5):
                print(", pausing " + runningContainer1.name + "\n")
                runningContainer1.pause()
            os.system('sudo taskset -a -cp 0-1 ' + pid)
            cpuNum = 2
        elif(cpuNum == 2 and cpu_usages[0] <= 40):
            # decrease number of CPUs, unpause job running on core 1
            print(math.floor(time.time()), file=f)
            if (indexContainers1 < 5):
                print(", un-pause " + runningContainer1.name + "\n")
                runningContainer1.unpause()
            os.system('sudo taskset -a -cp 0 ' + pid)
            cpuNum = 1
    else:
        if(cpuNum == 1 and cpu_usages[0] >= 85):
            print(math.floor(time.time()), file=f)
            os.system('sudo taskset -a -cp 0-1 ' + pid)
            runningContainer2and3.update(cpuset_cpus="2-3")
            cpuNum = 2
        elif(cpuNum == 2 and cpu_usages[0] <= 40):
            print(math.floor(time.time()), file=f)
            os.system('sudo taskset -a -cp 0 ' + pid)
            runningContainer2and3.update(cpuset_cpus="1-3")
            cpuNum = 1
        
    time.sleep(1)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
