#!/bin/bash
 
#an den exei parametrous, ektupwse to am
if [ $# -eq 0 ]; then
    echo '1058123-'
    exit
fi
 
############ arxi edit ##########
 
# an dwthoun 6 arguments
if [ $# -eq 6 ]
then
 
# checkarei an einai tupou: -f <file> --edit <id> <column> <value>
    if [ "$1" = "-f" -a "$3" = "--edit" ]
    then
        file=$2
        id=$4
        column=$5
        value=$6
 
# an i stili den einai metaksu 2-8 kanei exit
        if (($column > 8 | $column < 2))
        then
            exit
        fi
# an to id uparxei, allazei ti stili pou dwthike sti timi pou dwthike
        awk -v column="$column" -v id="$id" -v value="$value" 'BEGIN{FS="|";OFS="|"} { $column = ($1== id ? value : $column) }1' $file > tmp && mv tmp $file
        exit
 
# checkarei an einai tupou: --edit <id> <column> <value> -f <file>
    elif [ "$5" = "-f" -a "$1" = "--edit" ]
    then
        id=$2
        column=$3
        value=$4
        file=$6
        if (($column > 8 | $column < 2))
        then
            exit
        fi
 
# an to id uparxei, allazei ti stili pou dwthike sti timi pou dwthike
        awk -v column="$column" -v id="$id" -v value="$value" 'BEGIN{FS="|";OFS="|"} { $column = ($1== id ? value : $column) }1' $file > tmp && mv tmp $file
        exit
    fi
fi
################# telos edit ####################
 
################ arxi id    #################
#an dwthei prwta -f kai meta -id
if [ "$1" = "-f" -a "$3" = "-id" ]; then
    file="$2"
    id="$4"
 
#tupwnei ta pediaonoma,eponumo,imerominia genisis, tou id pou dothtike, diaxorismena me ena keno metaksu tous
    awk 'BEGIN{FS="|"; OFS;} $1=='$id' {print $2,$3,$5}' $file
 
#an dwthei prwta -id kai meta -f
elif [ "$1" = "-id" -a "$3" = "-f" ]
then
    file="$4"
    id="$2"
 
#tupwnei ta pediaonoma,eponumo,imerominia genisis, tou id pou dothtike, diaxorismena me ena keno metaksu tous
awk 'BEGIN{FS="|"; OFS;} $1=='$id' {print $2,$3,$5}' $file
elif [ "$1" = "-f" -a "$3" = "" ]
then
    file="$2"
    cat $file | egrep -v "^#.*"
    exit
fi
############### telos id ##############
 
 
options=$(getopt -o f: --long firstnames,lastnames,socialmedia,born-since:,born-until: -- "$@")
eval set -- "$options"
 
# thetw metavlites bornsince kai bornuntil 0 gia na diksw oti den exoun dwthei kai na ginei argotera epilogi
bornsince=0
bornuntil=0
while true; do
    case "$1" in
    -f ) #an arxika dwthei -f
 
# apothikevei to onoma tou arxeiou sti metavliti file
        file=$2
        shift 2
        ;;
 
#an dwthei --firstnames
    --firstnames )
 
# apothikeuei ti zitithike
        operation=fnames # apothikeuei ti zitithike
        shift;
 
        ;;
#an dwthei --lastnames
    --lastnames )
 
# apothikeuei ti zitithike
        operation=lnames # apothikeuei ti zitithike
        shift;
        ;;
    --born-since )
        operation=born
        bornsince=$2
        shift 2
        ;;
    --born-until )
        echo lel
        operation=born
        bornuntil=$2
        shift 2
        ;;
    --socialmedia )
        operation=social
        shift;
        echo social
        ;;
    -- ) shift; break;;
    * ) break;;
    esac
done
 
case "$operation" in
 
# an eixe zitithei firstnames
    fnames)
 
#ektupwnei ta firstnames alfavitika
        awk 'BEGIN{FS="|"} /^[^#]/ {print $3|"sort -u"}' $file
        ;;
 
# an eixe zitithei lastnames
    lnames)
 
#ektupwnei ta lastnames alfavitika
        awk 'BEGIN{FS="|"} /^[^#]/ {print $2|"sort -u"}' $file
        ;;
 
    social) ##TODO invert the results
        awk 'BEGIN{FS="|"} /^[^#]/ {print $9}' $file | sort | uniq -c
        echo lel
        ;;
 
# an eixe zitithei kapoia imerominia
    born)
 
# an exei dwthei mono born-until (to bornsince tha einai 0 giati den dwthike)
        if (( "$bornsince"==0 ))
        then
 
# ektupwse ola ta stoixeia twn atomwn me imerominia genisis<bornuntil
            awk -v bornuntil="$bornuntil" 'BEGIN{FS="|"} /^[^#]/ && $5<=bornuntil { print $0 }' $file
 
#an exei dwthei mono born-since (to bornuntil tha einai 0 giati den dwthike)
        elif (( "$bornuntil"==0 ))
        then
 
# ektupwse ola ta stoixeia twn atomwn me imerominia genisis>bornsince
            awk -v bornsince="$bornsince" 'BEGIN{FS="|"} /^[^#]/ && $5>=bornsince { print $0 }' $file
 
#an exoun dwthei kai bornsince kai bornuntil
        else
 
# ektupwse ta stoixeia twn atomwn me bornsince<imerominia genisis< bornuntil
            awk -v bornsince="$bornsince" -v bornuntil="$bornuntil" 'BEGIN{FS="|"} $5>=bornsince && $5<=bornuntil { print $0 }' $file
        fi
        ;;
esac
