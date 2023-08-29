Use Summer_2022_BaseBall
go
declare @a varchar(20)
declare @msg varchar(40)
set @a = (select format(count(*),'##,##0') from allstarfull)
select @msg = 'Allstarfull count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Appearances)
select @msg = 'Appearances count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from AwardsManagers)
select @msg = 'AwardsManagers count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from AwardsPlayers)
select @msg = 'AwardsPlayers count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from AwardsShareManagers)
select @msg = 'AwardsShareManagers count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from AwardsSharePlayers)
select @msg = 'AwardsSharePlayers count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Batting)
select @msg = 'Batting count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from CollegePlaying)
select @msg = 'CollegePlaying count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Fielding)
select @msg = 'Fielding count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from HallofFame)
select @msg = 'HallofFame count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from HomeGames)
select @msg = 'HomeGames count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Managers)
select @msg = 'Managers count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
---set @a = (select format(count(*),'##,##0') from Parks)
---select @msg = 'Parks count = ' + @a
---RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from People)
select @msg = 'People count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Pitching)
select @msg = 'Pitching count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Salaries)
select @msg = 'Salaries count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Schools)
select @msg = 'Schools count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from Teams)
select @msg = 'Teams count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
set @a = (select format(count(*),'##,##0') from TeamsFranchises)
select @msg = 'TeamsFranchises count = ' + @a
RAISERROR(@msg, 0, 1) WITH NOWAIT
