package WebService::Leanpub;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.2');

use LWP::UserAgent;

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;


# Module implementation here

my $lpurl = 'https://leanpub.com/';

sub new {
    my ($self, $api_key, $slug) = @_;
    my $type = ref($self) || $self;

    $self = bless {}, $type;

    $self->{api_key} = $api_key;
    $self->{slug}    = $slug;
    $self->{ua}      = LWP::UserAgent->new();

    return $self;
} # new()

sub get_individual_purchases {
    my ($self,$opt) = @_;
    my $req = { path => '/individual_purchases.json' };
    $req->{var} = { page => $opt->{page} } if ($opt->{page});
    return $self->_get_request($req);

} # get_individual_purchases()

sub get_job_status {
    my ($self) = @_;

    return $self->_get_request( { path => '/book_status.json' } );

} # get_job_status()

sub get_sales_data {
    my ($self) = @_;

    return $self->_get_request( { path => '/sales.json' } );

} # get_sales_data()

sub preview {
    my ($self) = @_;

    my $url = $lpurl . $self->{slug} . '/preview.json';
    my $form = {
	api_key => $self->{api_key},
    };
    my $res = $self->{ua}->post($url, $form);

    if ($res->is_success) {
	return $res->decoded_content;
    }
    return;
} # preview()

sub publish {
    my ($self,$opt) = @_;

    my $url = $lpurl . $self->{slug} . '/publish.json';
    my $form = {
	api_key => $self->{api_key},
    };
    my $res = $self->{ua}->post($url, $form);

    if ($res->is_success) {
	return $res->decoded_content;
    }
    return;
} # publish()

sub _get_request {
    my ($self,$opt) = @_;

    my $req = $lpurl . $self->{slug} . $opt->{path}
            . '?api_key=' . $self->{api_key};
    if ($opt->{var}) {
	my $vars = '';
	foreach my $var (keys %{$opt->{var}}) {
	    $vars .= "&$var=" . $opt->{var}->{$var}; # XXX HTML escape!
	}
	$req .= $vars;
    }
    my $res = $self->{ua}->get($req);

    if ($res->is_success) {
	return $res->decoded_content;
    }
    return;
} # _get_request()

1; # Magic true value required at end of module
__END__

=head1 NAME

WebService::Leanpub - Access the Leanpub web API.


=head1 VERSION

This document describes WebService::Leanpub version 0.0.1


=head1 SYNOPSIS

    use WebService::Leanpub;

    my $wl = WebService::Leanpub->new($api_key, $slug);

    $wl->get_individual_purchases( { slug => $slug } );

    $wl->get_job_status( { slug => $slug } );

    $wl->preview();

    $wl->get_sales_data( { slug => $slug } );

=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=head2 new($api_key, $slug)

Create a new WebService::Leanpub object.

Since you need an API key to access any function of the Leanpub API, you have
to give that API key as an argument to C<new()>.

The same holds for the I<slug> which is the part of the Leanpub URL denoting
your book. For instance if your books URL was
C<< https::/leanpub.com/your_book >>, the slug woud be I<your_book>.

=head2 get_individual_purchases()

=head2 get_individual_purchases( $opt )

Get the data for individual purchases.

Optionally this method takes as argument a hash reference with this key:

=over

=item C<< page >>

the page of the individual purchases data.

=back

=head2 get_job_status()

Get the status of the last job.

=head2 get_sales_data()

Get the sales data.

=head2 preview()

Start a preview of your book.

=head2 publish()

This will publish your book without emailing your readers.

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
WebService::Leanpub requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-webservice-leanpub@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Mathias Weidner  C<< <mamawe@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, Mathias Weidner C<< <mamawe@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


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
