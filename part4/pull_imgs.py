import docker

"""
Pulls all the PARSEC job images and creates an image with the corresponding job name.
"""

#list all parsec jobs and their tag
fft =  "anakli/parsec:splash2x-fft-native-reduced"
freqmine = "anakli/parsec:freqmine-native-reduced"
ferret = "anakli/parsec:ferret-native-reduced"
canneal = "anakli/parsec:canneal-native-reduced"
dedup = "anakli/parsec:dedup-native-reduced"
blackscholes = "anakli/parsec:blackscholes-native-reduced"

parsec_jobs = [fft, freqmine, ferret, canneal, dedup, blackscholes]
parsec_names = ["fft", "freqmine", "ferret", "canneal", "dedup", "blackscholes"]

client = docker.from_env()

for container in parsec_jobs:
    client.images.pull(container)

#create an image for all jobs
for job in parsec_jobs:
    name = parsec_names[0]
    temp = client.containers.create(job, name=name)
    parsec_names.pop(0)