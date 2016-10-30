open(A,"$ARGV[0]");
@data=<A>;
close(A);
$len=@data;
chomp(@data);

for($i=0;$i<$len;$i++)
	{
	@split=split(',',$data[$i]);
	$len1=@split;
	for($j=0;$j<$len1-1;$j++)
		{
		$str=$split[$j].','.$split[$j+1];
		print "$str ";
		}
	print "\n";
	}
