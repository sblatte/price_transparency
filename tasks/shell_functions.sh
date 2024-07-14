
`##This file defines shell functions that
# 1. Improve Makefiles' readability by compartmentalizing all the "if" statement around SLURM vs local executables.
# 2. Cause Stata to report an error to Make when the Stata log file end at an error.`;

python_pc_and_torque() {
	if command -v qsub > /dev/null ; then
		command1="module load gcc/6.2.0 python/3.7.6 openssl/1.1.1d";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="python3 $@";
			print_info Python $@;
        	qsub -v command1="$command1",command2="$command2" run.sh;
		else
			command2="python3 $@";
			jobname="${1%.*}";
			print_info Python $@;
			qsub -v command1="$command1",command2="$command2" -N "$jobname" -o "torquelogs/${jobname}.txt" -e "torquelogs/${jobname}_error.txt" run.sh;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Python $@;
        python $@;
	fi 
} ;

python_pc_and_slurm() {
    if command -v sbatch > /dev/null ; then
        command1="module load gcc/12.1.0 python/3.10.5";
        if [ "$1" == "--no-job-name" ]; then
            shift;
            command2="python3 $@";
            print_info Python $@;
            sbatch -W --export=command1="$command1",command2="$command2" run.sbatch;
        else
            command2="python3 $@";
            jobname="${1%.*}";
            print_info Python $@;
            sbatch -W --export=command1="$command1",command2="$command2" --job-name="$jobname" --output="slurmlogs/%x_%j.txt" --error="slurmlogs/%x_%j_error.txt" run.sbatch;
        fi;
    else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Python $@;
        python $@;
    fi
};


python_pc_and_torque_large_job() {
	if command -v qsub > /dev/null ; then
		command1="module load gcc/6.2.0 python/3.7.6 openssl/1.1.1d";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="python3 $@";
			print_info Python $@;
        	qsub -v command1="$command1",command2="$command2" run_large_job.sh;
		else
			command2="python3 $@";
			jobname="${1%.*}";
			print_info Python $@;
			qsub -v command1="$command1",command2="$command2" -N "$jobname" -o "torquelogs/${jobname}.txt" -e "torquelogs/${jobname}_error.txt" run_large_job.sh;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Python $@;
        python $@;
	fi 
} ;

python_pc_and_slurm_large_job() {
    if command -v sbatch > /dev/null ; then
        command1="module load gcc/12.1.0 python/3.10.5";
        if [ "$1" == "--no-job-name" ]; then
            shift;
            command2="python3 $@";
            print_info Python $@;
            sbatch -W --export=command1="$command1",command2="$command2" run_large_job.sbatch;
        else
            command2="python3 $@";
            jobname="${1%.*}";
            print_info Python $@;
            sbatch -W --export=command1="$command1",command2="$command2" --job-name="$jobname" --output="slurmlogs/%x_%j.txt" --error="slurmlogs/%x_%j_error.txt" run_large_job.sbatch;
        fi;
    else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Python $@;
        python $@;
    fi
};


R_pc_and_torque() {
	if command -v qsub > /dev/null ; then
		command1="module load gcc/6.2.0 mpich/3.2 R/3.6.3 gdal/2.4.4 geos/3.6.2 proj/4.9.3 udunits/2.2.26";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="Rscript $@";
			print_info R $@;
        	qsub -v command1="$command1",command2="$command2" run.sh;
		else
			command2="Rscript $@";
			jobname="${1%.*}";
			print_info R $@;
			qsub -v command1="$command1",command2="$command2" -N "$jobname" -o "torquelogs/${jobname}.txt" -e "torquelogs/${jobname}_error.txt" run.sh;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info R $@;
        Rscript $@;
	fi 
} ;

R_pc_and_slurm() {
	if command -v sbatch > /dev/null ; then
		command1="module load gcc/12.1.0 R/4.2.1 gdal/3.7.0 proj/9.2.0 udunits2 geos/3.11.2";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="Rscript $@";
			print_info R $@;
        	sbatch -W --export=command1="$command1",command2="$command2" run.sbatch;
		else
			command2="Rscript $@";
			jobname="${1%.*}";
			print_info R $@;
			sbatch -W --export=command1="$command1",command2="$command2" --job-name="$jobname" --output="slurmlogs/%x_%j.txt" --error="slurmlogs/%x_%j_error.txt" run.sbatch;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info R $@;
        Rscript $@;
	fi 
} ;

julia_pc_and_torque() {
	if command -v qsub > /dev/null ; then
		command1="module load gcc/6.2.0 julia/1.6.7";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="julia $@";
			print_info Julia $@;
        	qsub -v command1="$command1",command2="$command2" run.sh;
		else
			command2="julia $@";
			jobname="${1%.*}";
			print_info Julia $@;
			qsub -v command1="$command1",command2="$command2" -N "$jobname" -o "torquelogs/${jobname}.txt" -e "torquelogs/${jobname}_error.txt" run.sh;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Julia $@;
        julia $@;
	fi 
} ;

julia_pc_and_slurm() {
	if command -v qsub > /dev/null ; then
		command1="module load gcc/12.1.0 julia/1.9.0";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="julia $@";
			print_info Julia $@;
			sbatch -W --export=command1="$command1",command2="$command2" run.sbatch;
        	
		else
			command2="julia $@";
			jobname="${1%.*}";
			print_info Julia $@;
			sbatch -W --export=command1="$command1",command2="$command2" --job-name="$jobname" --output="slurmlogs/%x_%j.txt" --error="slurmlogs/%x_%j_error.txt" run.sbatch;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Julia $@;
        julia $@;
	fi 
} ;

print_info() {
	software=$1;
	shift; 
	if [ $# == 1 ]; then
		echo "Running ${1} via ${software}, waiting...";
    else
        echo "Running ${1} via ${software} with args = ${@:2}, waiting...";
	fi
} ;

stata_stats() {
	if command -v module > /dev/null ; then
		module load stata/18;
		print_info Stata $@;
        stata-mp -e $@;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info Stata $@;
        stata-mp -e $@;
	fi 
} ; 

stata_with_flag() {
	stata_stats $@;
	if [ "$1" == "--no-job-name" ]; then
		shift;
	fi ;
	LOGFILE_NAME=$(basename ${1%.*}.log);
	if grep -q '^r([0-9]*);$' ${LOGFILE_NAME}; then 
		echo "STATA ERROR: There are errors in the running of ${1} file";
		echo "Exiting Status: $(grep '^r([0-9]*);$' ${LOGFILE_NAME} | head -1)";
		exit 1;
	fi
} ;

stata_pc_and_slurm() {
	if command -v sbatch > /dev/null ; then
		command1="module load gcc/12.1.0 stata/18";
		export command1;
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="stata-mp -e $@";
			export command2;
			print_info Stata $@;
			sbatch -W run.sbatch;
		else
			command2="stata-mp -e $@";
			export command2;
			jobname="${1%.*}";
			print_info Stata $@;
			sbatch -W --job-name="$jobname" --output="slurmlogs/%x_%j.txt" --error="slurmlogs/%x_%j_error.txt" run.sbatch;
		fi;
	else
		if [ "$1" == "--no-job-name" ]; then
			shift;
		fi;
		print_info Stata $@;
		stata-mp -e $@;
	fi
} ;


wipe_directory() {
	for dir in input output temp; do
		if [ -d ../$dir ]; then
			rm -r ../$dir;
			echo "Directory ../$dir has been deleted.";
		fi;
	done;
	if [ -d ../report ]; then
		rm ../report/*.log || true;
		rm ../report/*.pdf || true;
		echo "../report/*.log and ../report/*.pdf have been deleted if present.";
		if [ -z "$(ls -A ../report)" ]; then
			rm -r ../report;
			echo "Directory ../report has been deleted.";
		fi;
	fi
} ;

push_ignore_paths() {
    current_branch="$(git branch | grep "*" | cut -b 3-)";
    cd "../../setup_environment/code" ;
    make -f personal_repos_outputs.mak main_repo_paths_UNDO ;
    echo -n "Pushing to ${current_branch}: Please type y to confirm (y/n)" ; 
    read -e yn ;
    if [ "$yn" = "y" ]; then
        git push origin "$current_branch";
    else
        echo "You did not push.";
    fi;
    make -f personal_repos_outputs.mak main_repo_paths;
} ;

pull_ignore_paths() {
    current_branch="$(git branch | grep "*" | cut -b 3-)";
    cd "../../setup_environment/code" ;
    make -f personal_repos_outputs.mak main_repo_paths_UNDO ;
    echo -n "Pulling from ${current_branch}: Please type y to confirm (y/n)" ; 
    read -e yn ;
    if [ "$yn" = "y" ]; then
        git pull origin "$current_branch";
    else
        echo "You did not pull.";
    fi;
    make -f personal_repos_outputs.mak main_repo_paths;
} ;

pip_install_pc_and_slurm() {
	if command -v sbatch > /dev/null ; then
		command1="module load python/booth/3.10";
		if [ "$1" == "--no-job-name" ]; then
			shift;
			command2="pip3 install -r $@";
			print_info pip3 install $@;
        	sbatch -W --export=command1="$command1",command2="$command2" run.sbatch;
		else
			command2="pip3 install -r $@";
			jobname1="${1%.*}_";
        	jobname2=$(echo ${@:2} | sed -e "s/ /_/g");
			print_info pip3 install $@;
			sbatch -W --export=command1="$command1",command2="$command2" --job-name="$jobname1$jobname2" run.sbatch;
		fi;
	else
        if [ "$1" == "--no-job-name" ]; then
            shift;
        fi;
        print_info pip3 install $@;
        pip3 install -r $@;
	fi
} 
