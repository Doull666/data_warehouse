# data_warehouse

数据仓库学习

## 大数据集群环境

### 集群配置

|节点|单节点磁盘|磁盘总和|单节点内存|内存总和|单节点cpu(物理核)|cpu总和|
|---|---|---|---|---|---|---|
|3|36.1G|108.3G|8G|24G|4|12||

### 参数调优

#### hdfs 调优

|参数| 调优                                                       | 作用                                       |
|---|----------------------------------------------------------|------------------------------------------|
|dfs.namenode.handler.count| python -c 'import math ; print int(math.log(3) * 20)'=21 | 指定NameNode 的服务器线程的数量,改不了最小30             |
| fs.trash.interval | 3h                                                       | 保留被误操作删除的 hdfs 上文件的时间                    |
| dfs.replication | 1                                                        | hdfs存放副本数                                |
| dfs.datanode.du.reserved | 2.1G                                                     | 设置磁盘容量预留多少的配置，防止hdfs磁盘写满导致系统或其他程序磁盘不足的情况 |

#### yarn 调优
1. 默认服务器物理核和虚拟核的转换比例是1:2, 4个物理core的服务器也就是拥有8虚拟8vcore ，取80%，即6
2. 因为该节点还存在其他服务，故需预留内存 10%，即 单节点以供yarn调度内存：8*0.8=6.4G
3. cloudera公司做过性能测试, 对于单任务，如果cpu大于等于5之后, cpu利用率反而不是很好（固定经验值），建议设置为4
4. 综合memory+vcore计算，vcore=4，container=1（6/4）；内存分配：6.4/1=6.4G
5. 在yarn上运行程序时每个task都是在独立的Container中运行的

|参数| 调优                                        | 作用    |
|---|-------------------------------------------|-------|
|yarn.nodemanager.resource.memory-mb| 6.4G                                      |表示yarn在该节点上可使用的物理内存总量，给服务器预留15%-20%|
|yarn.nodemanager.resource.cpu-vcores| 6                                         |服务器最多分配给nodemanager使用的虚拟核数|
|yarn.scheduler.minimum-allocation-vcores| 1                                         |一个container最少占用vcore数|
|yarn.scheduler.maximum-allocation-vcores| 4                                         |一个container最多占用vcore数|
|yarn.scheduler.minimum-allocation-mb| 512M                                      |单个任务可申请的最少物理内存|
|yarn.scheduler.maximum-allocation-mb| 6.4G                                      |单个任务可申请的最多物理内存|
|mapreduce.map.memory.mb| 6.4G                                      |一个MapTask可使用的资源上限，如果MapTask实际使用的资源量超过该值，则会被强制杀死，其值不要超过yarn.scheduler.maximum-allocation-mb|
|mapreduce.reduce.memory.mb| 6.4G                                      |一个 ReduceTask 可使用的资源上限。如果 ReduceTask 实际使用的资源量超过该值，则会被强制杀死，其值不要超过yarn.scheduler.maximum-allocation-mb|
|mapreduce.map.cpu.vcores| 4                                         |每个 MapTask 可使用的最多 cpu core 数目|
|mapreduce.reduce.cpu.vcores| 4                                         |每个 ReduceTask 可使用的最多 cpu core 数目|
|mapreduce.reduce.shuffle.parallelcopies| 10                                         |每个 Reduce 去 Map 中取数据的并行数|
|mapreduce.task.io.sort.mb| 200M                                      |   Shuffle环形缓冲区大小，默认100M;调大会减少环形缓冲区的溢写次数，减少磁盘IO，加快map处理速度 |
| mapreduce.map.sort.spill.percent | 90%                                       |      环形缓冲区溢写的阈值，默认80% |
| mapreduce.map.output.compress | true                                      |       MAP输出压缩 |
| mapreduce.map.output.compress.codec | org.apache.hadoop.io.compress.SnappyCodec |  压缩类型 |
| mapreduce.job.reduce.slowstart.completedmaps | 0.7/0.8                                   |  当MAP完成多少后，申请REDUCE资源开始执行REDUCE  |

#### hive 参数调优
|参数| 调优                                                | 作用    |
|---|---------------------------------------------------|-------|
|hive.auto.convert.join|true|在join问题上，让小表放在左边 去左链接（left join）大表，这样可以有效的减少内存溢出错误发生的几率，即 小表自动选择Mapjoin|

## 大数据集群性能测试
### 写性能测试
1. CDH 测试包目录：/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce
2. 执行命令：hadoop jar hadoop-mapreduce-client-jobclient-2.6.0-cdh5.16.2-tests.jar TestDFSIO -write -nrFiles 10 -fileSize 128MB
3. 测试内容：向 HDFS 集群写 10 个 128M 的文件
4. 测试结果：![write.png](img_2.png)

### 读性能测试
1. CDH 测试包目录：/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce
2. 执行命令：hadoop jar hadoop-mapreduce-client-jobclient-2.6.0-cdh5.16.2-tests.jar TestDFSIO -read -nrFiles 10 -fileSize 128MB
3. 测试内容：读取 HDFS 集群 10 个 128M 的文件
4. 测试结果：![read_4.png](img_4.png)

### 删除测试数据
1. 执行命令：hadoop jar hadoop-mapreduce-client-jobclient-2.6.0-cdh5.16.2-tests.jar TestDFSIO -clean

### 测试 Mapreduce 性能
1. 使用RandomWriter来产生随机数，每个节点运行10个Map任务，每个Map产生大约1G大小的二进制随机数
2. 执行命令：hadoop jar hadoop-mapreduce-examples-2.6.0-cdh5.16.2.jar randomwriter random-data


## 数据仓库构建
### 相关概念
####　维度退化（退化维度）
1. 将本属于维度表的属性退化至事实表，并剔除原本该维度表
2. 维度退化即没有对应的维度表
3. citycode这种我们也会冗余在事实表里面，但是它有对应的维度表，所以它不是退化维度


### 维度表与事实表的逻辑区分
1. 一般一对一的维度最终都会选择退化到事实表中，即一张维度表可能只会关联一张事实表，其他事实表都不会用到，那么为了避免过多的关联，会将这个维度表的
一些属性退化到事实表中
2. 一般一对多的维度会专门设置维度表，即一张维度表可能会被多张事实表关联，则会将这个维度表单独拎出来
3. 针对于公司的业务，其实可以把企业作为实体，相当于电商行业的人
