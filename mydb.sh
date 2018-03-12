#!/bin/bash
while (true)
do
read -p "myDB> " variable
###############createdb
function exist() {
cd $HOME/bashScripting/myDB
} 
function create() {
exist
tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)
db=$table
if [[ -d "$db" ]]
then
echo "database exists"
else
mkdir $db
fi
}
###################rename
function rename(){
exist
cd $usedb
from=$(echo "$variable" | awk '{ print tolower($3) }')
if [[ -f $from ]]
then
newname=$(echo "$variable" | awk '{ print tolower($5) }')
sed -i '1s/'"$from"'/'"$newname"'/' $from
sed -i '2s/'"$from"'/'"$newname"'/' $from
sed -i '4s/'"$from"'/'"$newname"'/' $from
mv $from $newname
mv "$from.txt" "$newname.txt"
else
echo "Table Not Found"
fi
}
###################desc
function desc() {
desctb=$(echo "$variable" | awk '{ print tolower($2) }')
descname=$(echo "$desctb" | cut -d ';' -f 1)
exist
cd $usedb
if [[ -f $descname ]]
then
lineNum=$(awk '/Primary key feild Number/{print NR}' $descname )
num=$((lineNum+1))
sed -e '1,3d' -e ''"$num"',$d' $descname
else
echo "Table Not Found"
fi
}
###################descFrom
function descFrom() {
desctb=$(echo "$variable" | awk '{ print tolower($3) }')
descname=$(echo "$desctb" | cut -d ';' -f 1)
exist
cd $usedb
if [[ -f $descname ]]
then
lineNum=$(awk '/Primary key feild Number/{print NR}' $descname )
num=$((lineNum+1))
sed -e '1,3d' -e ''"$num"',$d' $descname
else
echo "Table Not Found"
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
###################createTable
function create_table(){
exist
cd $usedb
tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)

if [[ ! -f $table ]]  #notNull , not exist
then
	touch $table;
	chmod +x $table;
	if [[ $? -eq 0 ]]; then
		echo -e ">>>>>>$table Table Structure" > $table;
		echo
		echo "Table Name:$table " >> $table;
		read -p "Enter The Number Of Columns : " tCol;
		echo "The Number Of Columns Is:$tCol" >> $table;
		echo
		echo -e ">>>>>>$table Columns" >> $table;
		echo
		for (( i = 1; i <= tCol ; i++ ))
		do
			read -p "Enter Name Of The Column Number [$i] : " ColName ;
			colArr[$i]=$ColName ; 
			echo  -n "$ColName" >> $table ;
			Type="Enter Column $ColName Type";
			select colType in number string int varchar
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
	      		    "int")
					    echo -e ":int" >> $table;
	      				break ;
	      				;;
	      			"varchar")
						echo -e ":varchar" >> $table;
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
		echo "$table Table Created Successfully";
	else	
		echo "Error Done While Creating the Table" ;
	fi
else	
	echo "This Table  Exists";
fi
}
##################droptable
function drop() {
exist
cd $usedb
tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)

if [[ -f "$table" ]]
then
read -p "Are You Sure Droping $table Database [Y/N] " response;
        case $response in 
                        [yY][eE][sS]|[yY]) 
                        rm -rf $table;
                        rm -rf $table.txt;
                        if [[ -f "$table.select" ]]
                        	then
                        	rm -rf $table.select;
                        fi
                         if [[ -f "$table.html" ]]
                        	then
                        	rm -rf $table.html;
                        fi
                         if [[ -f "$table.csv" ]]
                        	then
                        	rm -rf $table.csv;
                        fi
                         if [[ -f "$table.tmp" ]]
                        	then
                        	rm -rf $table.tmp;
                        fi
                ;;
esac
else
if [[ "$table" ]]
then
echo "ERROR 1051 (42S02): Unknown table 'database.$table'"
fi
fi
}
#######################usedb
function use() {
#pwd
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
##################list database
function list ()
{
exist
show=$(ls -d * | cut -d " " -f 10)
echo "$show" 
}
######################show tables
function showtb() {
exist
if [[ -d "$usedb" ]]
then
cd $usedb
see=$(ls -al | grep '^-' | awk -F: '{print $NF}' | cut -d " " -f2  )
echo "$see"  
else 
echo "ERROR 1046 (3D000): No database selected" 
fi
}
##################drop Column###########
function dropColumn() {
exist
cd $usedb

droptb=$(echo "$variable" | awk '{ print tolower($3) }') ###tablename
dropfile=$(echo "$droptb" | cut -d ';' -f 1) ###tablenme

word=$(echo "$variable" | awk '{ print tolower($6) }') ###field
wordfile=$(echo "$word" | cut -d ';' -f 1) ###field


if [[ -f "$dropfile" ]]
then
w=$(cat "$dropfile" | grep "$wordfile") #####search for field
wordValue=$(cat "$dropfile" | grep "$wordfile" | cut -d ":" -f1 ) ##### field
wv="$wordValue:" ###field:

if [[  "$wv" != ":" ]]
then
pk=$(tail -n 1 $dropfile | grep [1-9] | cut -d ":" -f 2) ####primary key value
pkline=$(($pk+4)) ###which line in the code represent the primary key

where=$(cat $dropfile | grep -n "$wordValue" | cut -d ":" -f 1) ####field in which line 
if [[ $where -ne $pkline && $pk -gt 1 && $pkline -gt $where ]] 
then

txtvar=$(($where-4)) ####line of field - 4 to know 

sed -i '/'"$wv"'/d' "$dropfile"


pk=$(($pk-1))

txt=$(wc -l "$dropfile" | cut -d " " -f1)
txt=$(($txt-5))

sed -i 's/[1-9]\+/'"$pk"'/' "$dropfile"
sed -i '3s/[1-9]\+/'"$txt"'/' "$dropfile"

array=$(cut -d ":" -f "$txtvar" "$dropfile.txt" ) ####get the field using number of the fields
for i in ${array[@]}; do
sed -i 's/'" ${i}:"'//' "$dropfile.txt"
done

echo "Query OK, 1 row affected (0.07 sec)"
else
####################
if [[ $where -eq $pkline ]]
then
echo "Can't Delete a Primary Key"
else

txtvar=$(($where-4))

sed -i '/'"$wv"'/d' "$dropfile"

key=$(tail -n 1 $dropfile | grep [1-9] | cut -d ":" -f 2)
key=$(($key-1))

txt1=$(wc -l "$dropfile" | cut -d " " -f1)
txt1=$(($txt1-5))

sed -i '3s/[1-9]\+/'"$txt1"'/' "$dropfile"

array=$(cut -d ":" -f "$txtvar" "$dropfile.txt" )

for i in ${array[@]}; do
sed -i 's/'": ${i}"'//' "$dropfile.txt"
done

echo "Query OK, 1 row affected (0.07 sec)"
fi
fi
else
echo "ERROR 1091 (42000): Can't DROP '$wordfile'; check that column/key exists"
fi
else
echo "Table Not Exists"
fi
}
###################addColumn
function addColumn() {
exist
cd $usedb
tableName=$(echo "$variable" | awk '{ print tolower($3) }')
column=$(echo "$variable" | awk '{ print tolower($5) }')
data=$(echo "$variable" | awk '{ print tolower($6) }')
if [[ -f $tableName ]]
then
lineNum=$(awk '/Primary key feild Number/{print NR}' $tableName )
#count=$(wc -l)
#line=$(($count-$lineNum))
lastLine=$(tail -n 1 $tableName)
coldata=$(cat $tableName | grep "$column:")
if [[ $coldata ]]
then
echo "Data Already Exists"
else

changecolumn=$(wc -l "$tableName" | cut -d " " -f1)
chcol=$(($changecolumn-4))

sed -i '3s/[1-9]\+/'"$chcol"'/' "$tableName"

sed -i '$d' $tableName
echo "$column:$data" >> $tableName
echo "$lastLine" >> $tableName
if [[ $data == "string" || $data == "varchar" ]]
	then
	sed -i "s/$/":\ null"/" "$tableName.txt"
elif [[ $data == "number" || $data == "int" ]]
	then
sed -i "s/$/":\ 0"/" "$tableName.txt"
fi	
fi
else
echo "Table Not Exist"
fi
}
##################datatypeChange########
function datatypeChange() {
tabname=$(echo "$variable" | awk '{ print tolower($3) }')
colName=$(echo "$variable" | awk '{ print tolower($6) }')
dt=$(echo "$variable" | awk '{ print tolower($7) }')
colval=$(cat $tabname | grep "$colName:") ##column1
datatyp=$(cat $tabname | grep "$colval" | cut -d ":" -f2 ) ##column2
firstcol=$(cat $tabname | grep "$colval" | cut -d ":" -f1 )
digit=$(cat $tabname | grep -n "$colval" | cut -d ":" -f1)

if [[ -f $tabname ]]
then
if [[ $colval ]] ##eg name:
then
###########check the first row
numtxt=$(head -n 1 "$tabname.txt")
lnum=$(($digit-4))
if [[ -z "$numtxt" ]] ###unset
then
sed -i 's/'"$colval"'/'"$firstcol:$dt"'/' "$tabname"
else
value=$(cat "$tabname.txt" | cut -d ":" -f$lnum)
if [[ $value =~ [1-9]+ && ($dt == "number" || $dt == "int") ]] 
then
sed -i 's/'"$colval"'/'"$firstcol:$dt"'/' "$tabname"
echo "Query OK, 1 row affected (0.07 sec)"
elif [[ $value =~ [A-Za-z]+ && ($dt == "string" || $dt == "varchar") ]]
then
sed -i 's/'"$colval"'/'"$firstcol:$dt"'/' "$tabname"
echo "Query OK, 1 row affected (0.07 sec)"
else
echo "The Datatype Doesn't Match the data inserted"
fi
fi
else
echo "Column Not Found"
fi
else
echo "Table Not Exist"
fi
}
##################Select################
function selectTable() {
exist
cd $usedb

tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)
echo "$table.select"
rm -rf "$table.select"
rm -rf "$table.html"
rm -rf "$table.csv"
rm -rf "$table.tmp"

if [[ -f "$table" ]] #####1
then
echo "1-field"
echo "2-more than one field"
echo "3-All"
read -p "#?" fieldVar

case $fieldVar in
"1")
descFrom
read -p "Enter column name : " columnData ##field name
read -p "Enter value : " valTxt
###################
wordfile=$(echo "$columnData" | cut -d ';' -f 1) ###field

w=$(cat "$table" | grep "$wordfile") #####search for field
wordValue=$(cat "$table" | grep "$wordfile" | cut -d ":" -f1 ) ##### field
wv="$wordValue:" ###field:

if [[  "$wv" != ":" ]] #########2
then
where=$(cat $table | grep -n "$wordValue" | cut -d ":" -f 1) ####field in which line 
txtvar=$(($where-4)) ####line of field - 4 to know 
fi ##########2
if [[ "$valTxt" =~ [*,?,+,.,^,$,-,'\b','\B','\<','\>'] ]] #########3
	then
echo "$columnData" >> "$table.select"
num1=$(echo "'{print \$$txtvar}'")
num3="awk $num1"
echo "cat '$table.txt' | $num3 | grep '$valTxt' | cut -d ":" -f1" > "$table.tmp"
bash "$table.tmp" >> "$table.select"
else
echo "$columnData" >> "$table.select"
num1=$(echo "'{print \$$txtvar}'")
num3="awk $num1"
echo "cat '$table.txt' | $num3 | grep '\<'$valTxt'\>' | cut -d ":" -f1" > "$table.tmp"
bash "$table.tmp" >> "$table.select"
	fi ###########3
    cat "$table.select" >> "$table.csv"

	choose
;; 
"2")
wordLine=$(wc -l "$table" | cut -d " " -f 1)
lne=$(($wordLine-5))
descFrom
addCol=0
read -p "Enter number of columns : " numCol

if [[ "$numCol" -gt "$lne" || "$numCol" -le "0" ]] ########
then
echo "number of Columns are not correct"
else

while [[ "$numCol" != "0" && "$numCol" -le "$lne" ]]
do
	addCol=$(($addCol+1))
	read -p "Enter Field $addCol : " feildword
	arr[$addCol]=$feildword

	feildnum=$(grep -n "$feildword" "$table"  | cut -d ":" -f1)
	feildnum=$(($feildnum-4))

	inputs[$addCol]="\$$feildnum,"
	numCol=$(($numCol-1))

done
read -p "Condition : " condition

# f1=$(echo "$condition" | cut -d "=" -f2 | cut -d "&" -f1)
# f2=$(echo "$condition" | cut -d "=" -f1)
# f3=$(grep -n $f2 "$table" |cut -d ":" -f1)
# f3=$(($f3-4))
# echo "$f"

a=$(echo "${inputs[@]}")
a=$(echo "${a::-1}")
printStat="'{ print $a; }'"
echo "${arr[@]}" >> "$table.select"
b="awk -F\":\" $printStat   $table.txt >> $table.select" 
echo "$b" > "$table.tmp"
bash "$table.tmp"
cat "$table.select" >> "$table.csv"

choose
fi
;;
"3")

insCount=$(wc -l "$table" | cut -d " " -f1)
insertCount=$(($insCount-5))

sequence=$(desc "$table" | sed -e '1,4d' -e ''$insCount'd' "$table" | cut -d ":" -f 1 | tr "\n" " ")

echo "${sequence[@]}" > "$table.csv"
cat "$table.txt" >> "$table.csv"

echo "${sequence[@]}" > "$table.select"
cat "$table.txt" >> "$table.select"

choose
;;
*)
echo "Please enter from the selected option"
;;

esac
else
	echo "Table Not Found"
fi ############1
}
###################choose
function choose()
{
echo "1-Show data using HTML"
echo "2-Show data using CSV"
read -p "Enter your choice : " page
case $page in
"1")
web
;;
"2")
libreoffice "$table.csv"
;;
*)
echo ""
cat "$table.select"
echo ""
;;
esac
}
###################webpage
function web(){
	web=$(echo "<html>"
echo "<head>"
echo "<style>"
echo "td tr table{
border:1px solid black;
}"
echo "</style>"
echo "</head>"
echo "<body>"
echo "<center>"
echo "<table style='border:1px solid black;' >" ;
print_header=true
while read INPUT ; do
  if $print_header;then
    print_header=false
  fi
  echo "<tr style='border:1px solid black;'><td style='border:1px solid black;'>${INPUT//,/</td><td>}</td></tr>" ;
done < "$table.csv" ;
echo "</center>"
echo "</table>" 
echo "</body>"
echo "</html>")
echo $web > "$table.html"
firefox "$table.html"
}
###################Insert###############
function insert(){
exist
cd $usedb

tab=$(echo "$variable" | awk '{ print tolower($3) }')
table=$(echo "$tab" | cut -d ';' -f 1)

if [[ -f "$table" ]]
then
if [[ ! -f "$table.txt" ]]
then
touch "$table.txt"
fi
insCount=$(wc -l "$table" | cut -d " " -f1)
insPk=$(tail -n 1 "$table" | cut -d ":" -f2)
insertCount=$(($insCount-5))

sequence=$(desc "$table" | sed -e '1,4d' -e ''$insCount'd' "$table" | cut -d ":" -f 1 | tr "\n" " ")
seqType=$(desc "$table" | sed -e '1,4d' -e ''$insCount'd' "$table" | cut -d ":" -f 2 | tr "\n" " ")


IFS=" " read -ra arr <<< "${seqType[@]}"

input=0
for i in $sequence
do
read -p "Enter value for $i :" value
 
flag="0"
if [[ "${arr[$input]}" == "string" || "${arr[$input]}" == "varchar" ]]
then
while [ $flag -eq 0 ]
do
if [[ $value =~ [A-Za-z] ]]
then
arrVal[$input]="$value:"
flag="1"
else
echo "What You insert must be string"
read -p "Enter value for $i :" value
flag="0"	
fi
done

elif [[ "${arr[$input]}" == "number" || "${arr[$input]}" == "int" ]]
then
while [ $flag -eq 0 ]
do
if [[ $value =~ [1-9] ]]
then
chk=$(cut -d ":" -f$insPk "$table.txt" | grep "$value")
echo "input $input"
echo "pk $insPk"
if [[ ! -z "$chk" && $(($input+1)) -eq $insPk ]]
then
echo "${sequence[@]}"
echo "Primary Key Duplicated"
read -p "Enter value for $i :" value
else
arrVal[$input]="$value:"
flag="1"
fi

else 
echo "What You insert must be number"
read -p "Enter value for $i :" value
flag="0"
fi
done
fi
input=$(($input+1))
done

valArr=$(echo "${arrVal[@]}")
valArr=$(echo "${valArr::-1}")
echo "${valArr[@]}" >> "$table.txt"
arrVal=("$@")
arr=("$@")
valArr=("$@")
chk=("$@")
else
echo "Table Not Found"
fi
}
#####Edit in only one record#####
edit_record()
{
tabdata=$(echo "$variable" | awk '{ print tolower($4) }')
tabledata=$(echo "$tabdata" | cut -d ';' -f 1)
datafile="$tabledata.txt"

while true 
  do 
   read -p " Enter  the number of Primarykey to edit the : " pkToEdit
   read -p " enter the old value You want to replace : " oldValue
   read -p " enter the new value You want to replace : " newValue
   sed -i "s/^${pkToEdit}: *${oldValue}*/${pkToEdit}: ${newValue}/" "$datafile"
   break
   done
}
#####Edit in  records#####
edit_records()
{
tabdata=$(echo "$variable" | awk '{ print tolower($4) }')
tabledata=$(echo "$tabdata" | cut -d ';' -f 1)
datafile="$tabledata.txt"
echo "$datafile"
while true 
  do 
   read -p " enter the old value You want to replace : " oldValue
   read -p " enter the new value You want to replace : " newValue
    
           sed -i 's/'"$oldValue"'/'"$newValue"'/'  "$datafile"
        
      break
  done
}
#####Delete row#####
deleteRw()
{
tabdata=$(echo "$variable" | awk '{ print tolower($3) }')
tabledata=$(echo "$tabdata" | cut -d ';' -f 1)
datafile="$tabledata.txt"
  while true 
  do 
   read -p "Enter The Primarykey You Want To Delete It's Record : " pkToDelete
    if [[ "$pkToDelete" ]]
     then 

     de=$(cat "$datafile" | grep "$pkToDelete:" )
     sed -i '/'"$de"'/d' "$datafile"
     break
    fi 
  done
}
##################input#################
var=$(echo "$variable" | awk '{ print tolower($1" "$2) }')
add=$(echo "$variable" | awk '{ print tolower($4) }')
aya=$(echo "$variable" | awk '{ print tolower($1" "$2" "$3) }')

seven=$(echo "$variable" | awk '{ print tolower($7) }')
three=$(echo "$variable" | awk '{ print tolower($3) }')
eight=$(echo "$variable" | awk '{ print tolower($8) }')

datatype=$(echo "$variable" | awk '{ print tolower($6) }')
columnName=$(echo "$variable" | awk '{ print tolower($5) }')
array=(number string int varchar)

use=$(echo "$variable" | awk '{ print tolower($1) }')

forlist=$(echo "$variable" | awk '{ print tolower($2) }')
list=$(echo "$forlist" | cut -d ';' -f 1)
#########exit########
quit=$(echo "$variable" | tr '[:upper:]' '[:lower:]' |cut -d ';' -f1)
if [[ $quit == "exit"  ||  $quit == "quit" && -z "$forlist" ]]
then
echo "BYE"	
break
###############Insert###################
elif [[ $var == "insert into" && -z "$add" ]]
then
insert
###############Select###################
elif [[ $var == "select from" && -z "$add" ]]
then 
selectTable
###############drop table###############
elif [[ $var == "drop table" && -z "$add" ]]
then 
drop
##################sort table
elif [[ $var == "sort table" ]]
then
sort_table
##################edit record
elif [[ $aya == "edit record from" ]]
then
edit_record
##################edit records
elif [[ $aya == "edit records from" ]]
then
edit_records
##################delete row
elif [[ $var == "delete from" ]]
then
deleteRw
##################create database
elif [[ $var == "create database" && -z "$add" ]]
then 
create
#####################use
elif [[ $use == "use" && -z "$three" ]]
then
use
######################desc
elif [[ $use == "desc" && -z "$three" ]]
then
desc
######################rename
elif [[ $var == "rename table" && $add == "to" && -z "$datatype" ]]
then 
rename
#######################drop Column
elif [[ $var == "alter table" && $add == "drop" && $columnName == "column" && -z "$seven" ]]
then
dropColumn
#######################Create table
elif [[ $var == "create table" && -z "$add" ]]
then
create_table
####################addColumn
elif [[ $var == "alter table" && $add == "add" && $columnName != "" && $datatype != "" && -z "$seven" ]]
then
count=0
for i in "${array[@]}"
do
	count=$(($count+1))
    if [[ "$i" == "${datatype}" ]] 
    then
    addColumn
    break
elif [[ "$i" != "${datatype}" &&  $count -eq ${#array[@]} ]]
	then
	echo "wrong datatype"
	break
fi
done
####################datatype change
elif [[ $var == "alter table" && $add == "alter" && $columnName == "column" && $datatype != "" && $seven != "" && -z "$eight" ]]
then
count=0
for i in "${array[@]}"
do
	count=$(($count+1))
    if [[ "$i" == "${seven}" ]] 
    then
    datatypeChange
    break
elif [[ "$i" != "${seven}" &&  $count -eq ${#array[@]} ]]
	then
	echo "wrong datatype"
	break
fi
done
####################list
elif [[ $use == "show" && $list == "databases" && -z "$three" ]]
then
list
elif [[ $use == "show"  && $list == "tables" && -z "$three" ]]
then 
showtb
else
echo "ERROR 1064 (42000): You have an error in your myDB syntax"
fi
done
