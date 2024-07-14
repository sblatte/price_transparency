# this script runs `make -nC` on all tasks looking for undefined variable warnings

TASKS=$(find ../.. -name 'Makefile' | sed "s|/code/Makefile||" | sed "s|\.\./\.\./||")
for task in $TASKS
do
    make_res=$(make --warn-undefined-variables -nC  ../../$task/code 2>&1 | grep 'undefined variable')
    if [ "$make_res" != "" ]
    then
        echo "$task/code/Makefile: $make_res"
    fi
done
