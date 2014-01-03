# plot memory layout
set terminal x11 persist # set terminal persist
set terminal x11 1 noraise # set the terminal in the background
#set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000

set title "cache usage"
set yrange [-2:16]
set ylabel "Is cache color used used"
set xlabel "cache color number"
set format x "%x" #set x-axis value in hex format
set xtics 2
set key off #turn off the legend

plot 'mem-layout.dat' using 2:3 pt 7 ps 1 # pt 7 gives a filled circle and ps 10 is the size


pause 5; #pause 5sec
refresh;
reread;
