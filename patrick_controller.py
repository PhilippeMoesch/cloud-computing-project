import psutil
import docker
import time
import os
import sys

"""
general idea: we run memcached on one or two cores, depending on the load. 
we use the other two or three cores to run the parsec jobs.
jobs with a high speedup are run alone (jobs 0-2), while jobs with a lower speedup are run in pairs (jobs 3-5).

this controller first pulls the images and then creates the containers.
if the containers already exist (docker containers list --all), they must be removed first.

"""

fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [freqmine, ferret, blackscholes, fft, canneal, dedup]
parsec_names = ["freqmine", "ferret", "blackscholes", "splash2x.fft", "canneal", "dedup"]

client = docker.from_env()

#pull all images
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

indexJob = 0
cpuNum = 2
pid = sys.argv[1]
runningContainers = []

#TODO: This should be a function. Runs the first container and appends it to the list of running containers.
os.system('sudo taskset -a -cp 0-1 ' + pid)
#really important that we define our own command here to run the job with multiple tasks
jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 3'"
jobName = "run_" + parsec_names[indexJob]
#especially detach is important, as it runs the job in the background
currentContainer = client.containers.run(parsec_jobs[indexJob], command=jobCommand, cpuset_cpus="2-3", detach=True, remove=False, name=jobName)
runningContainers.append(currentContainer)
print(time.time())
print(jobName + " started")

while(True):
    cpu_usages = psutil.cpu_percent(percpu=True)
    i = 0
    # checks whether a container exited in the meantime and runs a new container
    for i in range(len(runningContainers)):
        myJobName = runningContainers[i].name
        myContainer = client.containers.get(myJobName)
        if(myContainer.status == "exited"):
            print(time.time())
            print(myContainer.name + " done")
            runningContainers.pop(i)
            if(indexJob == 5):
                # no more jobs to run
                continue
            indexJob = indexJob + 1
            #TODO: this should be a function
            newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 3'"
            newJobName = "run_" + parsec_names[indexJob]
            stringCpuSet = "2-3"
            if(cpuNum == 1):
                stringCpuSet = "1-3"
            newContainer = client.containers.run(parsec_jobs[indexJob], command=newJobCommand, cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
            runningContainers.append(newContainer)
            print(newJobName + " started")

            # really hacky solution. launches a second container at the same time. should of course also be a function.
            if(indexJob == 3):
                runningContainers.pop(i)
                indexJob = indexJob + 1
                newJobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + parsec_names[indexJob] + " -i native -n 3'"
                newJobName = "run_" + parsec_names[indexJob]
                stringCpuSet = "2-3"
                if(cpuNum == 1):
                    stringCpuSet = "1-3"
                newContainer = client.containers.run(parsec_jobs[indexJob], command=newJobCommand, cpuset_cpus=stringCpuSet, detach=True, remove=False, name=newJobName)
                runningContainers.append(newContainer)
                print(newJobName + " started")

        i = i + 1

    # checks cpu usage of memcached and adjusts amount of cpus, if necessary
    if(cpuNum == 1 and cpu_usages[0] >= 90):
        print(time.time())
        os.system('sudo taskset -a -cp 0-1 ' + pid)
        for myContainer in runningContainers:
            myContainer.update(cpuset_cpus="2-3")
        cpuNum = 2
    elif(cpuNum == 2 and cpu_usages[0] <= 40):
        print(time.time())
        os.system('sudo taskset -a -cp 0 ' + pid)
        for myContainer in runningContainers:
            myContainer.update(cpuset_cpus="1-3")
        cpuNum = 1
    time.sleep(1)