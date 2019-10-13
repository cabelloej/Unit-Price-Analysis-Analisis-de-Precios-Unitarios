set talk off
set echo off

use ipptimat index ipptimat
zap
append from c:\EDUARDO\ipptimat
reindex
*******************************************
use ipptieqp index ipptieqp
zap
append from c:\EDUARDO\ipptieqp
reindex
*******************************************
use ipptimdo index ipptimdo
zap
append from c:\EDUARDO\ipptimdo
reindex
*******************************************
use ipppresu index ipppresu
zap
append from c:\EDUARDO\ipppresu
reindex
********************************************
use ippparti index ipppart1, ipppart2
zap
append from c:\EDUARDO\ippparti
reindex

use ippmater index ippmater
zap
append from c:\EDUARDO\ippmater
reindex

use ippequip index ippequip
zap
append from c:\EDUARDO\ippequip
reindex

use ippmdo index ippmdo
zap
append from c:\EDUARDO\ippmdo
reindex

use ippdate
zap
append from c:\EDUARDO\ippdate
reindex

use ippparde index ippparde
zap
append from c:\EDUARDO\ippparde
reindex

use ippvalge index ippvalge
zap
append from c:\EDUARDO\ippvalge
reindex

use ippvalde index ippvalde
zap
append from c:\EDUARDO\ippvalde
reindex

close all
return
