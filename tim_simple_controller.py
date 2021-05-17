import psutil
import docker
import time
import sys
import os
"""
Design options:
- pause, unpause                            run each job without stopping, just adjust core usage
- run jobs in sequence                      round robin, priority queue, dependent on the available cores, etc.
- monitor running jobs in lists             monitor them using the client.containers functions, or monitor them in another way
- always allocate 2 cores for memcached     allocate the cores for memcached on demand
- ...

Important Points:
- SLO of memcached below 2ms
- logs that show correct time (script wants UNIX Time) and if used, pause/unpause times of the container

SSH command to copy files from local to VM:
gcloud compute scp <LOCAL_FILE_PATH> <USER@VM_NAME>:~<REMOTE_FILE_PATH>

SSH command to connect
gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@<MACHINE_NAME> --zone europe-west3-a
"""
# <image_name> = client.containers.run(ferret, cpuset_cpus="1,2", detach=True, remove=True, name="parsec")
# <image_name>.update(cpuset_cpus="3,4")

client = docker.from_env()
pending_jobs = []
paused_jobs = []
pid = sys.argv[1]
#pulled = sys.argv[2]
#setup = sys.argv[3]

#run memcached (enter correct pid) on the first 2 cores
os.system('sudo taskset -a -cp 0-1 ' + pid)

#list all parsec jobs and their tag
fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [freqmine, ferret, blackscholes, fft, canneal, dedup]
parsec_names = ["freqmine", "ferret", "blackscholes", "splash2x.fft", "canneal", "dedup"]

client = docker.from_env()

for container in parsec_jobs:
    client.images.pull(container)
    print("pulled image for " + container)

#create an image for all jobs
for i,job in enumerate(parsec_jobs):
    name = parsec_names[i]
    temp = client.containers.create(job, name=name)
    pending_jobs.append(temp)
    print("created pending job " + name)
    
#running job list for each cpu
running = [[], [], [], []]

#helper functions
def add_job_running(job, core):
    running[core].append(job)
    print(job.name + " is running on core " + str(core) + " at: " + str(time.time()))

def remove_job_running(job, core):
    running[core].remove(job)
    print(job.name + " removed from core " + str(core)  + " at: " + str(time.time()))

def remove_job_finished(job, core):
    running[core].remove(job)
    print(job.name + " finished on core " + str(core)  + " at: " + str(time.time()))

def add_job_pause(job, core):
    paused_jobs.append(job)

def remove_job_paused(job, core):
    paused_jobs.remove(job)

def run_job(job, core):
    jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + job.name + " -i native -n 1'"
    currentContainer = client.containers.run(job.image, command=jobCommand, cpuset_cpus=str(core), detach=True, remove=False, name="run-" + job.name)
    add_job_running(currentContainer, core)

def update_job(job, new_core):
    job.update(cpuset_cpus=str(new_core))

def pause_job(job, core):
    job.pause()
    add_job_pause(job, core)
    remove_job_running(job,core)

def unpause_job(job, core):
    update_job(job, core)
    job.unpause()
    remove_job_paused(job, core)
    add_job_running(job, core)

def launch_new_job(core):
    #if there are still pending jobs take one and run it
    if(len(pending_jobs) > 0):
        currentJob = pending_jobs[0]
        print("start job: " + currentJob.name + " at " + str(time.time()))
        run_job(currentJob, core)
        pending_jobs.remove(currentJob)
    else:
        print("no more pending jobs")

#the loop where the controller does it's magic
while(True):
    #measure cpu usage of each core
    cpu_usages = psutil.cpu_percent(percpu=True)

    #check if a job was finished
    for coreNr, jobList in enumerate(running):
        for i, job in enumerate (jobList):
            #check if the job has finished execution
            if(job.status == "finished"):
                remove_job_finished(job, coreNr, i)

    for i,cpu in enumerate(cpu_usages):
        #the cores memcached runs on
        if(i >= 0 and i < 2):
            if(cpu >= 90 and len(running[i]) > 0):
                pause_job(running[i][0], i)
            if(cpu < 40):
                #check if we can resume a paused job
                if(len(paused_jobs) > 0):
                    job = paused_jobs[0]
                    unpause_job(job, i)
                #launch a new job
                else:
                    launch_new_job(i)
        #the memcache-free cores
        elif(i >= 2):
            if(cpu < 40):
                if(len(paused_jobs) > 0):
                    job = paused_jobs[0]
                    unpause_job(job, i)
                #launch a new job
                else:
                    launch_new_job(i)
            
    print(cpu_usages)
    time.sleep(1)


