import psutil
import docker
import time
import os
import sys
# sudo docker container stop run_canneal
# sudo docker container stop run_freqmine
# sudo docker system prune -a

fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [freqmine, ferret, blackscholes, fft, canneal, dedup]
parsec_names = ["freqmine", "ferret", "blackscholes", "splash2x.fft", "canneal", "dedup"]

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
indexContainers1 = 0

# let memcached run on cores 0 and 1
os.system('sudo taskset -a -cp 0-1 ' + pid)
   
jobCommand = lambda index, t : "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[index] + " -i native -n " + str(t) + "'"

# start freqmine job
#jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 2'"
jobName = "run_" + parsec_names[0]
currentContainer = client.containers.run(parsec_jobs[0], command=jobCommand(0,2), cpuset_cpus="2-3", detach=True, remove=False, name=jobName)
runningContainer2and3 = currentContainer
print(time.time())
print(jobName + " started")

# start canneal job
# jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 1'"
jobName = "run_" + parsec_names[4]
currentContainer = client.containers.run(parsec_jobs[4], command=jobCommand(4,1), cpuset_cpus="1", detach=True, remove=False, name=jobName)
currentContainer.pause()
runningContainer1 = currentContainer
print(time.time())
print(jobName + " started")

while(True):
    # get CPU values
    cpu_usages = psutil.cpu_percent(percpu=True)

    # check whether the job running on cores 2 and 3 exited by now
    # start a new one, if this is the case
    myJobName = runningContainer2and3.name
    myContainer = client.containers.get(myJobName)
    if(myContainer.status == "exited"):
        print(time.time())
        print(myContainer.name + " done")
        if(indexContainers2and3 == 2):
            #all jobs are already launched
            continue
        indexContainers2and3 = indexContainers2and3 + 1
        #newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexContainers2and3] + " -i native -n 2'"
        newJobName = "run_" + parsec_names[indexContainers2and3]
        stringCpuSet = "2-3"
        newContainer = client.containers.run(parsec_jobs[indexContainers2and3], command=jobCommand(indexContainers2and3,2), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
        runningContainer2and3 = newContainer
        print(newJobName + " started")

    # check whether the job running on core 1 exited by now
    # start a new one, if this is the case
    myJobName = runningContainer1.name
    myContainer = client.containers.get(myJobName)
    if(myContainer.status == "exited"):
        print(time.time())
        print(myContainer.name + " done")
        if(indexContainers1 == 2):
            #all jobs are already launched
            continue
        indexContainers1 = indexContainers1 + 1
        #newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexContainers1 + 3] + " -i native -n 1'"
        newJobName = "run_" + parsec_names[indexContainers1]
        stringCpuSet = "1"
        newContainer = client.containers.run(parsec_jobs[indexContainers1], command=jobCommand(indexContainers1 + 3, 1), cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
        runningContainer1 = newContainer
        print(newJobName + " started")

    # check whether it's necessary to adjust the number of CPUs memcached has available
    if(cpuNum == 1 and cpu_usages[0] >= 90):
        # increase number of CPUs, pause job running on core 1
        print(time.time())
        runningContainer1.pause()
        os.system('sudo taskset -a -cp 0-1 ' + pid)
        cpuNum = 2
    elif(cpuNum == 2 and cpu_usages[0] <= 40):
        # decrease number of CPUs, unpause job running on core 1
        print(time.time())
        os.system('sudo taskset -a -cp 0 ' + pid)
        runningContainer1.unpause()
        cpuNum = 1
    time.sleep(1)
