out_folder='transcripts/6-20-2020/combined/'
json_out='out/'
audio_folder='Audio_Files/6-20-2020/'
tr_folder='transcripts/6-20-2020/'

cpus=`nproc`
# cpus=`sysctl -n hw.physicalcpu`

docker_id=`docker ps  | grep gentle | awk '{print $1}'`

echo $cpus $docker_id 

mkdir -p $out_folder 
mkdir -p $json_out

for filename in $audio_folder*.mp3; do
	
    base=`echo $filename | awk -F\/ '{print $NF }' | awk -F_ '{print $1 "_" $2}'`
    audio="$base.mp3"
    tr="$base.csv"
    jsn="$base.json"
    tx="$base.txt"

    if [ ! -f $json_out$jsn ]; then 
    	echo "started $base `date`" 

	    python3 csv2text.py $tr $tr_folder $out_folder

	    docker cp $audio_folder$base*.mp3 "$docker_id:/$base.mp3"
	    docker cp $out_folder$tx "$docker_id:/$tx"
	    docker exec -i $docker_id python /gentle/align.py --nthreads $cpus -o "/$jsn" "/$audio" "/$tx"
	    docker cp "$docker_id:/$jsn" $json_out$jsn
	    
	    # cleanup
	    docker exec -i $docker_id rm "/$audio" "/$jsn" "/$tx"
	    echo "done $base `date`" 
    fi
done


for filename in $audio_folder*.aac; do
	
    base=`echo $filename | awk -F\/ '{print $NF }' | awk -F_ '{print $1 "_" $2}'`
    audio="$base.aac"
    tr="$base.csv"
    jsn="$base.json"
    tx="$base.txt"

    if [ ! -f $json_out$jsn ]; then 

		echo "started $base `date`" 

	    python3 csv2text.py $tr $tr_folder $out_folder

	    docker cp $audio_folder$base*.aac "$docker_id:/$base.aac"
	    docker cp $out_folder$tx "$docker_id:/$tx"
	    docker exec -i $docker_id python /gentle/align.py --nthreads $cpus -o "/$jsn" "/$audio" "/$tx"
	    docker cp "$docker_id:/$jsn" $json_out$jsn
	    
	    # cleanup
	    docker exec -i $docker_id rm "/$audio" "/$jsn" "/$tx"
	    echo "done $base `date`" 
	fi
done

