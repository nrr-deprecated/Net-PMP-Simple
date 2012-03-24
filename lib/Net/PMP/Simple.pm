package Net::PMP::Simple;

use 5.010;
use strictures;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::LWP::UserAgent qw[ UserAgent ];

use DateTime;
use HTTP::Request::Common;
use LWP::UserAgent;
use Try::Tiny;
use URI::Escape;

has 'lwp_instance' => (
	is => 'rw',
	isa => 'UserAgent',
	coerce => 1,
);

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

=head2 BUILD

=cut

sub BUILD
{
}

=head2 __authentication_url

=cut

sub __authentication_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	return unless my $username = $options{username};
	return unless my $password = $options{password};
	my %query_parameters = (
		'j_username' => $username,
		'username' => $username,
		'j_password' => $password,
		'domainName' => 'LDAP',
		'submit' => '',
	);
	return POST(
		$options{base_url} . '/j_security_check',
		[%query_parameters]
	);
}

sub __initialization_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	return GET($options{base_url} . '/PassTrixMain.cc');
}

sub __resource_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	return unless $options{account};
	return unless $options{resource};
	my %query_parameters = (
		'RequestType' => 'PasswordRetrieved',
		'SUBREQUEST' => 'XMLHTTP'
		'account' => $options{account},
		'resource' => $options{resource},
	);
	return GET(
		$options{base_url} . '/jsp/xmlhttp/AjaxResponse.jsp',
		[%query_parameters],
	);
}

sub __generate_password_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	my $time;
	my %query_parameters = (
		'RequestType' => 'generate',
		'Rule' => 'Standard',
		'time' => $time,
	);
	return GET(
		$options{base_url} . '/jsp/xmlhttp/AjaxResponse.jsp',
		[%query_parameters],
	);
}

sub __change_password_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	return unless $options{account};
	return unless $options{resource};
	my %query_parameters = (
		'RequestType' => 'PasswordChange',
		'hostName' => $host_name,
		'accountName' => $account_name,
		'defaultvalue_schar1' => $password,
		'notes' = 'N/A',
	);
	return GET(
		$options{base_url} . '/jsp/xmlhttp/AjaxResponse.jsp',
		[%query_parameters],
	);
}

sub __create_resource_request
{
	my ($self, %options) = @_;
	return unless $options{base_url};
	return unless $options{account};
	return unless $options{resource};
	my %query_parameters = (
		'SysName' => $resource,
		'DNSName' => '',
		'SysType' => 'Application',
		'group' => 'Default Group',
		'desc' => 'Managed App',
		'dept' => '',
		'resourceURL' => $resource_url,
		'location' => $location,
		'Rule' => 'Standard',
		'resourcedefaultvalue_char1' => $application,
		'tmp' => $resource,
		'User1' => '',
		'Pass1' => '',
		'spassword' => '',
		'isEnforcePolicy' => 'false',
		'cpassword' => '',
		'Note1' => '',
		'Domain1' => '',
		'UserAccount' => '',
		'Password' => '',
		'Notes' => '',
		'Domain' => '',
		'ConfirmPass' => '',
		'Password' => $password,
		'Domain' => '',
		'Notes' => '',
		'ConfirmPass' => $password,
		'UserAccount' => $account,
		'remotesync' => '0',
		'remotemode' => 'ssh',
	);
	return POST(
		$options{base_url} . '/jsp/xmlhttp/AjaxResponse.jsp',
		[%query_parameters],
	);
}

=head2 __authentication_options

=cut

sub __authentication_options
{
	my ($self, %options) = @_;
}

=head2 authenticate

=cut

sub authenticate
{
	my ($self, %options) = @_;
	return unless $options{username};
	return unless $options{password};
	return $self->lwp_instance->request($self->__authentication_request(%options)); 
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

=item * GitHub Issues (report bugs here)

L<https://github.com/nrr/Net-PMP-Simple/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-PMP-Simple>

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
