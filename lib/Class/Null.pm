package Class::Null;

use vars '$VERSION';
$VERSION = '1.04';

my $singleton;

sub new { $singleton ||= bless {}, shift }
sub AUTOLOAD {
    *{$AUTOLOAD} = sub { Class::Null->new };
    goto &$AUTOLOAD;
}


1;

__END__

=head1 NAME

Class::Null - Implements the Null Class design pattern

=head1 VERSION

This document describes version 1.04 of C<Class::Null>.
    
=head1 SYNOPSIS

  use Class::Null;
  use Class::MethodMaker::Util
    new_with_init => 'new',
    new_hash_init => 'new_hash',
    get_set_std   => 'log';

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

  use Class::MethodMaker::Util
    new_hash_init => 'new',
    get_set_std   => 'log';

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

This object with null functionality is what is called a null object. We can
create the object the usual way, using the C<new()> constructor, and call any
method on it, and all methods will do the same - nothing. (Actually, it
returns another C<Class::Null> object, enabling method chaining.) It's
effectively a catch-all object. We can use this class with our own object
like this:

  package MyObject;

  use Class::Null;
  use Class::MethodMaker::Util
    new_with_init => 'new',
    new_hash_init => 'new_hash',
    get_set_std   => 'log';

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
C<Class::MethodMaker::Util>'s C<new_hash_init> option doesn't let us define an
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

=head1 METHODS

=over 4

=item new()

Returns the singleton null object.

=item any other method

Returns another singleton null object so method chaining works.

=back

=head1 DIAGNOSTICS

There are no diagnostics for this module.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-class-null@rt.cpan.org>, or through the web interface at
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

Copyright 2004-2005 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

