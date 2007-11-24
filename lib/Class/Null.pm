package Class::Null;

use warnings;
use strict;

our $VERSION = '1.09';

use overload
    'bool'   => sub { 0 },
    '""'     => sub { '' },
    '0+'     => sub { 0 },
    fallback => 1;

sub new { our $singleton ||= bless {}, shift }
sub AUTOLOAD { our $singleton }


1;

__END__



=head1 NAME

Class::Null - Implements the Null Class design pattern

=head1 SYNOPSIS

  use Class::Null;

  # some class constructor and accessor declaration here

  sub init {
    my $self = shift;
    ...
    $self->log(Class::Null->new);
    ...
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

  use base 'Class::Accessor';
  __PACKAGE__->mk_accessors(qw(log));

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
is a better way. We can ensure that there is always a log object that we can
call C<log()> on, even if it doesn't do very much (or in fact, anything at
all).

This object with null functionality is what is called a null object. We can
create the object the usual way, using the C<new()> constructor, and call any
method on it, and all methods will do the same - nothing. (Actually, it
always returns the same C<Class::Null> singleton object, enabling method
chaining.) It's effectively a catch-all object. We can use this class with our
own object like this:

  package MyObject;

  use Class::Null;

  # some class constructor and accessor declaration here

  sub init {
    my $self = shift;
    ...
    $self->log(Class::Null->new);
    ...
  }

  sub do_it {
    my $self = shift;
    $self->log->log(level => 'debug', message => 'starting to do it');
    ...
    $self->log->log(level => 'debug', message => 'still doing it');
    ...
    $self->log->log(level => 'debug', message => 'finished doing it');
  }

This is only one example of using a null class, but it can be used whenever
you want to make an optional helper object into a mandatory helper object,
thereby avoiding unnecessarily complicated checks and preserving the
transparency of how your objects are related to each other and how they
call each other.

Although C<Class::Null> is exceedingly simple it has been made into a
distribution and put on CPAN to avoid further clutter and repetitive
definitions.

=head1 METHODS

=over 4

=item new()

Returns the singleton null object.

=item any other method

Returns another singleton null object so method chaining works.

=back

=head1 OVERLOADS

=over 4

=item Boolean context

In boolean context, a null object always evaluates to false.

=item Numeric context

When used as a number, a null object always evaluates to 0.

=item String context

When stringified, a null object always evaluates to the empty string.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<classnull> tag.

=head1 VERSION 
                   
This document describes version 1.09 of L<Class::Null>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-class-null@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2005-2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

