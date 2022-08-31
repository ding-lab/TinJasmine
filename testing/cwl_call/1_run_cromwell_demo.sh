source /opt/ibm/lsfsuite/lsf/conf/lsf.conf

PWD=$(pwd)
CWL_ROOT_H=$PWD/../..
CWL="$CWL_ROOT_H/cwl/TinJasmine.v1.3.vep-100.cwl"

CONFIG="cromwell-config/cromwell-config-db.compute1-filedb.dat"
YAML="yaml/TinJasmine.C3L-00017.yaml"

# Cromwell v78 
JAVA="/opt/java/openjdk/bin/java"
CROMWELL="/app/cromwell-78-38cd360.jar"

# from https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase
# Connecting to the database section
# Note also database section in config file
CMD="$JAVA -Dconfig.file=$CONFIG -jar $CROMWELL run -t cwl -i $YAML $CWL"

echo Running: $CMD
eval $CMD

rc=$?
if [[ $rc != 0 ]]; then
    >&2 echo Fatal error $rc: $!.  Exiting.
    exit $rc;
fi

