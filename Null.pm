package Class::Null;
our $VERSION = '0.01';
sub new { bless {}, shift }
sub AUTOLOAD {}

1;

__END__

=head1 NAME

Class::Null - Implements the Null Class design pattern

=head1 SYNOPSIS

  use Class::Null;
  use Class::MethodMaker
    new_with_init => 'new',
    new_hash_init => 'new_hash',
    get_set       => 'log';

  sub init {
    my $self = shift;
    $self->log(Class::Null->new);
    $self->new_hash(@_);
  }

  sub do_it {
    my $self = shift;
    $self->log->log(level => 'debug', message => 'starting to do it');
    ...
    $self->log->log(level => 'debug', message => 'still doing it');
    ...
    $self->log->log(level => 'debug', message => 'finished doing it');
  }

=head1 DESCRIPTION

This class implements the Null Class design pattern.

Suppose that methods in your object want to write log messages to a log
object. The log object is possibly stored in a slot in your object and
can be accessed using an accessor method:

  package MyObject;

  use Class::MethodMaker
    new_hash_init => 'new',
    get_set       => 'log';

  sub do_it {
    my $self = shift;
    $self->log->log(level => 'debug', message => 'starting to do it');
    ...
    $self->log->log(level => 'debug', message => 'still doing it');
    ...
    $self->log->log(level => 'debug', message => 'finished doing it');
  }

The log object simply needs to have a C<log()> method that accepts
two named parameters. Any class defining such a method will do, and
C<Log::Dispatch> fulfils that requirement while providing a lot of
flexibility and reusability in handling the logged messages.

You might want to log messages to a file:

  use Log::Dispatch;

  my $dispatcher = Log::Dispatch->new;

  $dispatcher->add(Log::Dispatch::File->new(
    name      => 'file1',
    min_level => 'debug',
    filename  => 'logfile'));

  my $obj = MyObject->new(log => $dispatcher);
  $obj->do_it;

But what happens if we don't define a log object? Your object's methods
would have to check whether a log object is defined before calling the
C<log()> method. This leads to lots of unwieldy code like

  sub do_it {
    my $self = shift;
    if (defined (my $log = $self->log)) {
      $log->log(level => 'debug', message => 'starting to do it');
    }
    ...
    if (defined (my $log = $self->log)) {
      $log->log(level => 'debug', message => 'still doing it');
    }
    ...
    if (defined (my $log = $self->log)) {
      $log->log(level => 'debug', message => 'finished doing it');
    }
  }

The proliferation of if-statements really distracts from the actual call
to C<log()> and also distracts from the rest of the method code. There
is a better way. We could ensure that there is always a log object that
we can call C<log()> on, even if it doesn't do very much (or in fact,
anything at all).

This object with null functionality is what is called a null object. The
null class implementation is rather simple:

  package Class::Null;
  sub new { bless {}, shift }
  sub AUTOLOAD {}

So we can create the object the usual way, using the C<new()>
constructor, and call any method on it, and all methods will do the same -
nothing. It's effectively a catch-all object. We can use this class with
our own object like this:

  package MyObject;

  use Class::Null;
  use Class::MethodMaker
    new_with_init => 'new',
    new_hash_init => 'new_hash',
    get_set       => 'log';

  sub init {
    my $self = shift;
    $self->log(Class::Null->new);
    $self->new_hash(@_);
  }

  sub do_it {
    my $self = shift;
    $self->log->log(level => 'debug', message => 'starting to do it');
    ...
    $self->log->log(level => 'debug', message => 'still doing it');
    ...
    $self->log->log(level => 'debug', message => 'finished doing it');
  }

Note that we define two constructors (C<new()> and C<new_hash()>) since
C<Class::MethodMaker>'s C<new_hash_init> option doesn't let us define an
object initialization method, whereas C<new_with_init> doesn't process
named arguments. So we define both and call the constructor that processes
named arguments from our C<init()> method.

This is only one example of using a null class, but it can be used
whenever you want to make an optional helper object into a mandatory
helper object, thereby avoiding unnecessarily complicated checks and
preserving the transparency of how your objects are related to each
other and how they call each other.

Although C<Class::Null> is exceedingly simple it has been made into a
distribution and put on CPAN to avoid further clutter and repetitive
definitions.

=head1 AUTHOR

Marcel GrE<uuml>nauer, E<lt>marcel@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
