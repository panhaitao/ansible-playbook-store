rm -rvf result/*
mkdir -pv result/
/home/apache-jmeter-5.2.1/bin/jmeter -n -t 0831.jmx -l result/result.jtl -e -o result -R ab-1,ab-2,ab-3,ab-3,ab-4,ab-5,ab-6,ab-7,ab-8,ab-9,ab-10,ab-11,ab-12,ab-13,ab-14,ab-15,ab-16,ab-17,ab-18,ab-19,ab-20,ab-21,ab-22,ab-23,ab-24,ab-25,ab-26,ab-27,ab-28,ab-29,ab-30,ab-31,ab-31,ab-32,ab-33,ab-34,ab-35,ab-36,ab-37,ab-38,ab-39,ab-40
