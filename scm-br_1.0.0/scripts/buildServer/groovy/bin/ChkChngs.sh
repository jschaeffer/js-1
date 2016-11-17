#!/bin/bash

echo "./RelComp.sh $Component $vVersion $pVersion $Metadata $BUILD_TAG"
cd /opt/checkouts/${Component}
pwd

echo "<u>Commit summaries since last released version :</u> <b>$PriorVersion</b></u><br>" >> /tmp/${Component}_prob.html

echo "<pre>" >> /tmp/${Component}_prob.html

git log --graph --abbrev-commit --decorate --format=format:'<font color=blue>%h</font>-<font color=green>(%ad)</font><font color=black><b>%s</b></font><font color=grey>- (%an)</font><font color=red>%d</font>' --date=short v_${PriorVersion}..v_4.0.0_158 >> /tmp/${Component}_prob.html

echo "</pre>" >> /tmp/${Component}_prob.html
echo "<hr>" >> /tmp/${Component}_prob.html

echo "<p>" >> /tmp/${Component}_prob.html

exit
