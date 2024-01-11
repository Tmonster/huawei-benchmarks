CREATE TABLE IF NOT EXISTS time_info(
	benchmark_name VARCHAR,
	benchmark VARCHAR,
	system VARCHAR, 
	run_type VARCHAR,
	query_name VARCHAR,
	"Time" DOUBLE,
	Active BIGINT,
	"Active(anon)" BIGINT,
	"Active(file)" BIGINT,
	AnonHugePages BIGINT,
	AnonPages BIGINT,
	Bounce BIGINT,
	Buffers BIGINT,
	Cached BIGINT,
	CommitLimit BIGINT,
	Committed_AS BIGINT,
	DirectMap1G BIGINT,
	DirectMap2M BIGINT,
	DirectMap4k BIGINT,
	Dirty BIGINT,
	FileHugePages BIGINT,
	FilePmdMapped BIGINT,
	HardwareCorrupted BIGINT,
	HugePages_Free BIGINT,
	HugePages_Rsvd BIGINT,
	HugePages_Surp BIGINT,
	HugePages_Total BIGINT,
	Hugepagesize BIGINT,
	Hugetlb BIGINT,
	Inactive BIGINT,
	"Inactive(anon)" BIGINT,
	"Inactive(file)" BIGINT,
	KReclaimable BIGINT,
	KernelStack BIGINT,
	Mapped BIGINT,
	MemAvailable BIGINT,
	MemFree BIGINT,
	MemTotal BIGINT,
	Mlocked BIGINT,
	NFS_Unstable BIGINT,
	PageTables BIGINT,
	Percpu BIGINT,
	SReclaimable BIGINT,
	SUnreclaim BIGINT,
	SecPageTables BIGINT,
	Shmem BIGINT,
	ShmemHugePages BIGINT,
	ShmemPmdMapped BIGINT,
	Slab BIGINT,
	SwapCached BIGINT,
	SwapFree BIGINT,
	SwapTotal BIGINT,
	Unevictable BIGINT,
	VmallocChunk BIGINT,
	VmallocTotal BIGINT,
	VmallocUsed BIGINT,
	Writeback BIGINT,
	WritebackTmp BIGINT,
	Zswap BIGINT,
	Zswapped BIGINT
);

create table if not exists proc_mem_info(
	Name VARCHAR, -- hyperdMain
	Umask VARCHAR, -- 0002
	State VARCHAR, -- S (sleeping)
	Tgid BIGINT, -- 2125
	Ngid BIGINT, -- 0
	Pid BIGINT, -- 2125
	PPid BIGINT, -- 2107
	TracerPid BIGINT, -- 0
	Uid VARCHAR, -- 1000	1000	1000	1000
	Gid VARCHAR, -- 1000	1000	1000	1000
	FDSize BIGINT, -- 64
	Groups VARCHAR, -- 4 20 24 25 27 29 30 44 46 119 120 1000
	NStgid BIGINT, -- 2125
	NSpid BIGINT, -- 2125
	NSpgid BIGINT, -- 2125
	NSsid BIGINT, -- 1151
	VmPeak BIGINT, --  5762476 kB
	VmSize BIGINT, --  5762476 kB
	VmLck BIGINT, --        0 kB
	VmPin BIGINT, --        0 kB
	VmHWM BIGINT, --  1583052 kB
	VmRSS BIGINT, --  1583052 kB
	RssAnon BIGINT, --   198604 kB
	RssFile BIGINT, --  1384448 kB
	RssShmem BIGINT, --        0 kB
	VmData BIGINT, --   694184 kB
	VmStk BIGINT, --      132 kB
	VmExe BIGINT, --    77972 kB
	VmLib BIGINT, --     2348 kB
	VmPTE BIGINT, --     3912 kB
	VmSwap BIGINT, --        0 kB
	HugetlbPages BIGINT, --        0 kB
	CoreDumping BIGINT, -- 0
	THP_enabled BIGINT, -- 1
	Threads BIGINT, -- 56
	SigQ VARCHAR, -- 0/126203
	SigPnd VARCHAR, -- 0000000000000000
	ShdPnd VARCHAR, -- 0000000000000000
	SigBlk VARCHAR, -- 0000000000000000
	SigIgn VARCHAR, -- 0000000001001000
	SigCgt VARCHAR, -- 00000001000046fa
	CapInh VARCHAR, -- 0000000000000000
	CapPrm VARCHAR, -- 0000000000000000
	CapEff VARCHAR, -- 0000000000000000
	CapBnd VARCHAR, -- 000001ffffffffff
	CapAmb VARCHAR, -- 0000000000000000
	NoNewPrivs BIGINT, -- 0
	Seccomp BIGINT, -- 0
	Seccomp_filters BIGINT, -- 0
	Speculation_Store_Bypass VARCHAR, -- thread vulnerable
	SpeculationIndirectBranch VARCHAR, -- conditional enabled
	Cpus_allowed VARCHAR, -- ffff
	Cpus_allowed_list VARCHAR, -- 0-15
	Mems_allowed VARCHAR, -- 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
	Mems_allowed_list BIGINT, -- 0
	voluntary_ctxt_switches BIGINT, -- 46
	nonvoluntary_ctxt_switches BIGINT -- 0
);