use Test::More tests => 32;
BEGIN { use_ok('Class::Null') };
my $o = Class::Null->new;
isa_ok($o, 'Class::Null');
my @l = ('A'..'Z', 'a'..'z', '_');

for (1..10) {
	my $method = join '' => map { $l[rand@l] } 1..10;
	ok(do { $o->$method, 1 }, "can $method()");
}

for (1..10) {
	my $method = join '' => map { $l[rand@l] } 1..10;
	is($o->$method, undef, "$method() returns undef");

	# Now it will have installed the method via *{$AUTOLOAD}. Check
	# it's still ok.

	is($o->$method, undef, "$method() returns undef");
}

