import psutil
import docker
import time
import sys
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
# <image_name> = client.containers.run(ferret, cpuset_cpus="1,2", detach=True, remove=True, name="parsec", working_dir=".")
# <image_name>.update(cpuset_cpus="3,4")

client = docker.from_env()
i = 0
parsec_jobs = ["fft", "freqmine", "ferret", "canneal", "dedup", "blackscholes"]
pending_jobs = []
paused_jobs = []
pid = sys.argv[1]

#run memcached (enter correct pid) on the first 2 cores
os.system('sudo taskset -a -cp 0-1 ' + pid)

#running job list for each cpu
running = [[], [], [], []]

#helper functions
def add_job_running(job, core):
    running[core].append(job)
    print(job + "is running on core " + str(core) + "at: " + time.time())

def remove_job_running(job, core, index):
    running[core].pop(index)
    print(job + "removed from core " + str(core)  + "at: " + time.time())

def remove_job_finished(job, core, index):
    running[core].pop(index)
    print(job + "finished on core " + str(core)  + "at: " + time.time())

def add_job_pause(job, core):
    paused_jobs.append(job)
    print(job + "is now paused and no longer running on core " + str(core)  + "at: " + time.time())

def remove_job_pause(job, core):
    paused_jobs.remove(job)
    print(job + "was unpaused and running on core " + str(core)  + "at: " + time.time())

def run_job(jobName, core, jobCommand):
    jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + jobName + " -i native -n 1'"
    currentContainer = client.containers.run(jobName, command=jobCommand, cpuset_cpus=str(core), detach=True, remove=False, name="run-"+jobName)
    add_job_running(currentContainer)

def update_job(job, new_core):
    job.update(cpuset_cpus=str(new_core))
    print(job + " is now running on core " + new_core + "at: " + time.time())

def pause_job(job, core):
    job.pause()
    add_job_pause(job, core)

def unpause_job(job, core, jobCommand):
    update_job(job, core, jobCommand)
    job.unpause()
    remove_job_pause(job, core)

def launch_new_job(core):
    #if there are still pending jobs take one and run it
    if(len(pending_jobs) > 0):
        currentJob = pending_jobs[0]
        jobName = currentJob.name()
        jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + jobName + " -i native -n 1'"
        run_job(jobName, core, jobCommand)
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
        if(i > 0 and i < 2):
            if(cpu >= 90 and len(running[i] > 0)):
                pause_job(running[i][0], i)
            if(cpu < 40):
                #check if we can resume a paused job
                if(len(paused_jobs > 0)):
                    job = paused_jobs[0]
                    jobCommand = "/bin/sh -c './bin/parsecmgmt -a run -p " + job.name + " -i native -n 1'"
                    unpause_job(job, i, jobCommand)
                #launch a new job
                else:
                    launch_new_job(i)
        #the memcache-free cores
        elif(i >= 2):
            if(cpu < 40):
                #launch a new job
                launch_new_job(i)
            
    print(cpu_usages)
    time.sleep(1)


