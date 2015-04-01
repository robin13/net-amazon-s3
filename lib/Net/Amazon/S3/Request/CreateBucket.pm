package Net::Amazon::S3::Request::CreateBucket;
{
  $Net::Amazon::S3::Request::CreateBucket::VERSION = '0.60';
}
use Moose 0.85;
extends 'Net::Amazon::S3::Request';

# ABSTRACT: An internal class to create a bucket

has 'bucket'    => ( is => 'ro', isa => 'BucketName',      required => 1 );
has 'acl_short' => ( is => 'ro', isa => 'Maybe[AclShort]', required => 0 );
has 'location_constraint' =>
    ( is => 'ro', isa => 'Maybe[LocationConstraint]', required => 0 );

__PACKAGE__->meta->make_immutable;

sub http_request {
    my $self = shift;

    my $headers
        = ( $self->acl_short )
        ? { 'x-amz-acl' => $self->acl_short }
        : {};

    my $content = '';
    if ( defined $self->location_constraint
        && $self->location_constraint eq 'EU' )
    {
        $content
            = "<CreateBucketConfiguration><LocationConstraint>"
            . $self->location_constraint
            . "</LocationConstraint></CreateBucketConfiguration>";
    }

    return Net::Amazon::S3::HTTPRequest->new(
        s3      => $self->s3,
        method  => 'PUT',
        path    => $self->bucket . '/',
        headers => $headers,
        content => $content,
    )->http_request;
}

1;

__END__

=pod

=head1 NAME

Net::Amazon::S3::Request::CreateBucket - An internal class to create a bucket

=head1 VERSION

version 0.60

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::CreateBucket->new(
    s3                  => $s3,
    bucket              => $bucket,
    acl_short           => $acl_short,
    location_constraint => $location_constraint,
  )->http_request;

=head1 DESCRIPTION

This module creates a bucket.

=for test_synopsis no strict 'vars'

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=head1 AUTHOR

Pedro Figueiredo <me@pedrofigueiredo.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Amazon Digital Services, Leon Brocard, Brad Fitzpatrick, Pedro Figueiredo.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
