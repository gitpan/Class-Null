use Test::More tests => 12;
BEGIN { use_ok('Class::Null') };
my $o = Class::Null->new;
isa_ok($o, 'Class::Null');
my @l = ('A'..'Z', 'a'..'z', '_');

for (1..10) {
	my $method = join '' => map { $l[rand@l] } 1..10;
	ok(do { $o->$method, 1 }, "can $method()");
}
