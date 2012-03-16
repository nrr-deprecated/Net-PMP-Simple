package Net::PMP::Simple;

use 5.010;
use strictures;

use Moose;

use HTTP::Request::Common;
use LWP::UserAgent;
use Try::Tiny;
use URI::Escape;

=head1 NAME

Net::PMP::Simple - The great new Net::PMP::Simple!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::PMP::Simple;

    my $foo = Net::PMP::Simple->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=cut

=head2 __authentication_url

=cut

sub __authentication_url {
	my ($self, %options) = @_;
	return unless $options{base_url};
	return $options{base_url} . '/j_security_check';
}

=head2 __authentication_options

=cut

sub __authentication_options {
	my ($self, %options) = @_;
}

=head2 __authenticate

=cut

sub __authenticate {
	my ($self, %options) = @_;
	return unless $options{username};
	return unless $options{password};
	return LWP::UserAgent->new->request(POST $self->__authentication_url(base_url => 'https://pmp/'), 
}

=head1 AUTHOR

Nathaniel R Reindl, C<< <nrr at corvidae.org> >>

=head1 BUGS

Most definitely.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::PMP::Simple


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-PMP-Simple>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-PMP-Simple>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-PMP-Simple>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-PMP-Simple/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Nathaniel R Reindl.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

__PACKAGE__->meta->make_immutable;

1; # End of Net::PMP::Simple
