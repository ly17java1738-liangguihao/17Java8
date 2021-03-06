--创建商品类别表 （Category）
create table Category(
Cid int primary key identity(1,1),
Cname nvarchar(20) unique not null,
Description nvarchar(25) null 
)
--创建商品信息表 （Ware）
create table Ware(
Wid int primary key,
Wname nvarchar(30) unique not null,
Cid int not null foreign key references Category(Cid),
PurchasePrice decimal(10,2) not null,--进价
SalesPrice decimal(10,2) not null,--售价
Amount decimal(10,2) not null--库存量
)

--创建员工表 （Employee）
create table Employee(
Eid int primary key identity(1001,1),
Ename nvarchar(4) not null,
Epassword nvarchar(10) check(len(Epassword)>6),
Remark nvarchar(50)
)

--创建销售记录表 （Salesinfo）
create table Salesinfo(
Sid int primary key identity(1,1),
Wid int foreign key references Ware(Wid) not null,
SalesDate datetime not null,
SalesAmount decimal(10,2) not null,
Eid int not null foreign key references Employee(Eid)
)

--添加数据于 商品类别表（Category）
insert into Category(cname,description) values('食品类')
insert into Category(cname,description) values('日化类')
insert into Category(cname,description) values('服装类')
insert into Category(cname,description) values('家电类')

--添加数据于 商品信息表 （Ware）
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61601','康帅傅方便面',1,'3.8','5','500')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61602','农夫三泉矿泉水',1,'0.1','2','6000')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61603','嘿人牙膏',2,'2.3','6','2333')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61604','瓢柔洗发露',2,'10','18','2333')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61605','adivas运动服',3,'50','388','200')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61606','HIKE运动鞋',3,'20','288','150')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61607','美 白勺 电风扇',4,'100','258','100')
insert into Ware(Wid,Wname,Cid,PurchasePrice,SalesPrice,Amount)values('61608','老 木反 抽油烟机',4,'1500','3000','50')

--添加数据于 员工表 （Employee）
insert into Employee(Ename,Epassword)values('隔壁老王','1234567896')
insert into Employee(Ename,Epassword)values('犀利哥','1234567897')
insert into Employee(Ename,Epassword)values('梁非凡','1234567898')
insert into Employee(Ename,Epassword)values('方本','1234567899')

--添加数据于 销售记录表 （Salesinfo）
update Ware set Amount=Amount-1 where Wname='嘿人牙膏'
insert into Salesinfo(Wid,SalesDate,SalesAmount,Eid)values('61603','2017-12-03','1',1001)
update Ware set Amount=Amount-20 where Wname='农夫三泉矿泉水'
insert into Salesinfo(Wid,SalesDate,SalesAmount,Eid)values('61602','2017-12-19','1',1002)

--查询表
select*from Category
select*from Ware
select*from Employee
select*from Salesinfo


--1.查询每件商品的编号，名称，单品利润并从高到底进行排序
select wid,Wname,SalesPrice-PurchasePrice as 利润 from ware order by 利润 desc
--2.统计每件商品的销售量，显示商品名称及库存量，按销售量从高到低排序
select Wname,sum(SalesAmount) as 销售量 from Ware W,SalesInfo S where
W.wid=S.wid group by Wname order by sum(SalesAmount) desc
--3.统计每类商品的销售量,显示商品类别及销售量
select cname,sum(SalesAmount) as  销售量
from Category c,Ware w,SalesInfo s
where c.cid=w.cid and w.wid=s.wid 
group by c.cname
--4.统计每种商品到目前的盈利总额
select w.wname,sum(s.salesamount*(w.salesprice-w.purchaseprice))
from ware w,salesInfo s
where w.wid=s.wid group by w.wname
--5.收银员2号销售5件1号商品
update ware set amount=amount-5 where wid=61602
insert into salesInfo(Wid,eid,salesdate,salesamount) values(61602,1002,'2012-06-30',5)
--6.按照销售总额对收银员排序
select e.ename,sum((w.salesprice-w.purchaseprice)*s.salesamount) as 销售总额
from employee e,salesInfo s,ware w where e.eid=s.eid and w.wid=s.wid
group by e.ename order by 销售总额 desc
--7.查询商品销售量排在前五名的商品名称及销量
select top 5 w.wname,sum(s.salesamount) 销量
from ware w,salesInfo s where w.wid=s.wid
group by w.wname order by 销量 desc
--8.统计2017年的商品销售量排在前五名的商品名称及销量
select top 5 w.wname,sum(s.salesamount) 销量
from ware w,salesInfo s where w.wid=s.wid and s.salesdate
between'2017-12-03'and '2017-12-19' group by w.wname
order by 销量 desc
--9.统计每个员工在2017年的销量，显示员工名称及销售数量
select e.ename,sum(s.salesamount) 销量 from employee e,salesInfo s
where e.eid=s.eid and s.salesdate between'2017-12-03'and '2017-12-19' 
group by e.ename order by 销量 desc
--10.统计2017年的总利润
select sum((w.salesprice-w.purchaseprice)*s.salesamount)
from ware w,salesInfo s where w.wid=s.wid and s.salesdate
between'2017-12-03'and '2017-12-19'









