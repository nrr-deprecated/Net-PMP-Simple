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

has 'user_agent' => (
	is => 'rw',
	isa => 'UserAgent',
);

has 'base_url' => (
	is => 'rw',
	isa => 'Str',
);

has 'resource_path' => (
	is => 'ro',
	isa => 'Str',
	default => '/jsp/xmlhttp/AjaxResponse.jsp',
);

has 'authentication_path' => (
	is => 'ro',
	isa => 'Str',
	default => '/j_security_check',
);

has 'username' => (
	is => 'rw',
	isa => 'Str',
);

has 'password' => (
	is => 'rw',
	isa => 'Str',
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

sub BUILD
{
	my ($self) = @_;

	$self->user_agent(LWP::UserAgent->new(
		cookie_jar => HTTP::Cookies->new,
	);
}

sub __authentication_url
{
	my ($self) = @_;

	return $self->base_url . $self->authentication_path;
}

sub __resource_url
{
	my ($self) = @_;

	return $self->base_url . $self->resource_path;
}

sub __authentication_request
{
	my ($self, %options) = @_;

	my %query_parameters = (
		'j_username' => $self->username,
		'username' => $self->username,
		'j_password' => $self->password,
		'domainName' => 'LDAP',
		'submit' => '',
	);
	return POST(
		$self->__authentication_url,
		[%query_parameters],
	);
}

sub __initialization_request
{
	my ($self, %options) = @_;

	return GET(
		$self->base_url . '/PassTrixMain.cc'
	);
}

sub __fetch_resource_request
{
	my ($self, %options) = @_;
	return unless my $account = $options{account};
	return unless my $resource = $options{resource};

	my %query_parameters = (
		'RequestType' => 'PasswordRetrieved',
		'SUBREQUEST' => 'XMLHTTP'
		'account' => $account,
		'resource' => $resource,
	);
	return GET(
		$self->__resource_url,
		[%query_parameters],
	);
}

sub __generate_password_request
{
	my ($self, %options) = @_;

	my $time;
	my %query_parameters = (
		'RequestType' => 'generate',
		'Rule' => 'Standard',
		'time' => $time,
	);
	return GET(
		$self->__resource_url,
		[%query_parameters],
	);
}

sub __change_password_request
{
	my ($self, %options) = @_;
	return unless my $host_name = $options{host_name};
	return unless my $account_name = $options{account_name};
	return unless my $password = $options{password};

	my %query_parameters = (
		'RequestType' => 'PasswordChange',
		'hostName' => $host_name,
		'accountName' => $account_name,
		'defaultvalue_schar1' => $password,
		'notes' = 'N/A',
	);
	return GET(
		$self->__resource_url,
		[%query_parameters],
	);
}

sub __create_resource_request
{
	my ($self, %options) = @_;
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
		$self->__resource_url,
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

=head2 get_resource

=cut

=head2 create_resource

=cut

=head2 change_password

=cut

=head2 generate_password

=cut



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

no Moose;
__PACKAGE__->meta->make_immutable; # End of Net::PMP::Simple
