import psutil
import docker
import time
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
parsec_jobs = ["fft", "freqmine", "ferret", "canneal", "dedup", "blackscholes"]
pending_jobs = []
paused_jobs = []

#running job list for each cpu
running = [[], [], [], []]

#the loop where the controller does it's magic
while(True):
    #measure cpu usage of each core
    cpu_usages = psutil.cpu_percent(percpu=True)

    for i,cpu in enumerate(cpu_usages):
        
        #if we need to reduce cpu usage of a core with memcached on it
        if(cpu >= 90 and i < 2):
            #if there is a job running on this core
            if(len(running[i]) != 0):
                temp = running[i][0]
                #pause one of them
                temp.pause()
                #remove from running list, add to paused
                running[i].pop(0)
                paused_jobs.append(temp)
            
        #if we can do more computations
        elif (cpu <= 50):
            #check if there are paused jobs
            if(len(pending_jobs) > 0):
                job = pending_jobs[0]
                #remove from paused list, add to running list
                pending_jobs.pop(0)
                running[i].append(job)
                #update the job before starting it
                job.update(cpuset_cpus=str(i))
                #start it on this core
                job.start()
            #check if there are pending jobs
            elif(len(paused_jobs) > 0):
                #unpause it on this core
                job = paused_jobs[0]
                #remove from paused list, add to running list
                paused_jobs.pop(0)
                running[i].append(job)
                #update the job before starting it
                job.update(cpuset_cpus=str(i))
                job.unpause()
    print(cpu_usages)
    print(running)
    time.sleep(1)