#!/bin/bash
while (true)
do
read -p "myDB> " variable

function exist() {
cd $HOME/alaa/myDB
} 



#####Create_table#####
function create_table(){

tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)
exist
cd $usedb
if [[ ! -f $table ]] 
then
	touch $table;
	chmod +x $table;
	if [[ $? -eq 0 ]]; then
		echo -e "#################$table Structure###############" > $table;
		echo "Table Name:$table " >> $table;
		read -p "Enter The Number Of Columns : " tCol;
		echo "The Number Of Columns Is:$tCol" >> $table;
		echo -e "#################$table Columns###############" >> $table;
		echo
		for (( i = 1; i <= tCol ; i++ ))
		do
			read -p "Enter Name Of The Column Number [$i] : " ColName ;
			colArr[$i]=$ColName ; 
			echo  -n "$ColName" >> $table ;
			Type="Enter Column $ColName Type";
			select colType in number string
	      	do
	      		case $colType in
	      			"number")
					    echo -e ":number" >> $table;
	      				break ;
	      				;;
	      			"string")
						echo -e ":string" >> $table;
	      				break ;
	      				;;
	      			*)
				echo "You Must Choose The Column Data Type"
	      		esac
	      	done
	    done
	    while true; 
	    do
			i=1;
			for col in "${colArr[@]}"; 
			do
				echo $i")"$col;
				i=$((i+1)) ;
			done
			read -p "Detect Primarykey value : " Pkey;
			if [ $Pkey -le $tCol -a $Pkey -gt 0 ]
			then 
			    echo "Primary key feild Number : "$Pkey >> $table;
			    break ;
			else
				echo "You Must Detect Primarykey";
				continue ;
			fi 	
		done
		   colArrIndex=1 
		        while [ $colArrIndex -le $tCol ]
		        do
		         if [ $colArrIndex -eq $tCol ]
		          then echo -e "${colArr[colArrIndex]}" >> $table; 
		         else 
		          echo -n "${colArr[colArrIndex]}:" >> $table;
		         fi 
		         colArrIndex=$((colArrIndex+1));
		        done
		       echo "############################################################" >> $table;  
		       
		echo "$table Table Created Successfully";
	else	
		echo "Error Done While Creating the Table" ;
	fi
else	
	echo "This Table  Exists";
fi
}

var=$(echo "$variable" | awk '{ print tolower($1" "$2) }')


if [[ $var == "create table" ]]
then
create_table
fi