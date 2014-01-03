#!/bin/bash
# $1 domID
#omit the first two lines and last line; extract the mfn as first colum, and use domID as the second colum

#gnuplot periodicly draw
gnuplot ./plot-mem.gnu &
gnuplot ./plot-cache.gnu &

CACHE_COLOR_MASK=0x7f

########get domID#############
xl list | sed 's/\s\s*/|/g' | tail -n +2 | gawk -F '[|]' '{print $2}' > domID.dat

while [ 1 ]
do
    for domID in $(xl list | sed 's/\s\s*/|/g' | tail -n +2 | gawk -F '[|]' '{print $2}')
    do
        if [ $domID = 0 ]; then continue; fi
        echo "dump mfn of" $domID " with xen-mfndump " $domID
        xen-mfndump dump-p2m $domID > dom$domID-mem.dat
        #note: xen-mfndump the number followed by a blank! awk has to match the blank
        tail -n +3 dom$domID-mem.dat | head -n -1 | gawk --non-decimal-data -v COLOR_MASK="$CACHE_COLOR_MASK" -v DOMID="$domID" -F '[=(]' '{printf "%s\t 0x%x \t %d\n", $5, and($5, COLOR_MASK),DOMID}' >> mem-layout-tmp.dat
    done
    cp -f mem-layout-tmp.dat mem-layout-tmpall.dat
    #get dom0 and VMM's mfn
    xen-mfndump dump-m2p |tail -n +3|head -n -1 > m2p.dat
    awk -F '[\t=]' 'FNR==NR {domUsMFN[$1]=1; next} (!($2 in domUsMFN) && $NF != "0xffffffffffffffff"){printf "%s\n",$2}' mem-layout-tmp.dat m2p.dat | gawk --non-decimal-data -v COLOR_MASK="$CACHE_COLOR_MASK" '{printf "%s \t 0x%x \t %d\n", $1, and($1, COLOR_MASK), -1}' >> mem-layout-tmpall.dat
    mv -f mem-layout-tmp.dat mem-layout-domUs.dat
    mv -f mem-layout-tmpall.dat mem-layout.dat
    echo "draw mem-layout at `date`"
    sleep 30
done
