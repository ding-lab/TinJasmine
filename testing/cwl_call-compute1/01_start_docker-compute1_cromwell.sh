IMAGE="mwyczalkowski/cromwell-runner"

VOLUME_MAP="/storage1/fs1/m.wyczalkowski /home/m.wyczalkowski/Projects /storage1/fs1/m.wyczalkowski/Active/cromwell-data "

# absolute path to location of TinJasmine
CWL_ROOT="/cache1/fs1/home1/Active/home/m.wyczalkowski/Projects/TinJasmine/TinJasmine.dev"

export LSF_DOCKER_NETWORK=host && $CWL_ROOT/submodules/WUDocker/start_docker.sh -I $IMAGE -M compute1 $VOLUME_MAP
