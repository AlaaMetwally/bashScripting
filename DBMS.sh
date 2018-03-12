#!/bin/bash
while (true)
do
read -p "myDB> " variable

function exist() {
cd $HOME/alaa/myDB
} 

#####Use DB#####
function use() {
db=$(echo "$variable" | awk '{ print tolower($2) }')
usedb=$(echo "$db" | cut -d ';' -f 1)
exist
if [[ -d "$usedb"  ]]
then
cd $usedb
echo "Database changed to $usedb"
else
echo "ERROR 1049 (42000): Unknown database '$usedb' "
fi
}

#####show DB#####
function list ()
{
exist
show=$(ls -d * | cut -d " " -f 10)
echo "$show" 
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

#####Sort table#####

function sort_table(){
	sorttab=$(echo "$variable" | awk '{ print tolower($3) }')
    tablesort=$(echo "$sorttab" | cut -d ';' -f 1)
    filename="$tablesort.txt"
    exist
    cd $usedb


read -p "Enter col name: " col
read -p "Enter col type: " coltype

wordfile=$(echo "$col" | cut -d ';' -f 1)
w=$(cat "$tablesort" | grep "$wordfile")
wordValue=$(cat "$tablesort" | grep "$wordfile" | cut -d ":" -f1 )
wv="$wordValue:"

if [[  "$wv" != ":" ]] 
then
where=$(cat $tablesort | grep -n "$wordValue" | cut -d ":" -f 1) 
txtvar=$(($where-4))
fi

 while true 
	do
	echo "Enter Type of sort"  
	echo "1)asc"
	echo "2)desc" 

	read -p "#?" var

	case $var in
	 "1")
        sort -t ":" -k"$txtvar" "$filename"
        break
           ;;

	 "2")
	    sort -t ":" -k"$txtvar" -r "$filename"
	    break
	      ;;
		 
		*)
			echo "You Must Choose type of sort"
	esac
	done
}

#####List tables#####
function list ()
{
exist
show=$(ls -d * | cut -d " " -f 10)
echo "$show" 
}

################################################################

var=$(echo "$variable" | awk '{ print tolower($1" "$2) }')
forlist=$(echo "$variable" | awk '{ print tolower($2) }')
list=$(echo "$forlist" | cut -d ';' -f 1)
use=$(echo "$variable" | awk '{ print tolower($1) }')

if [[ $var == "create table" ]]
then
create_table

elif [[ $var == "sort table" ]]
then
sort_table

elif [[ $use == "show"  && $list == "tables" ]]
then 
showtb

fi