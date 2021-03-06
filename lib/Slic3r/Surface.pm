package Slic3r::Surface;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK   = qw(S_TYPE_TOP S_TYPE_BOTTOM S_TYPE_INTERNAL S_TYPE_INTERNALSOLID S_TYPE_INTERNALBRIDGE S_TYPE_INTERNALVOID);
our %EXPORT_TAGS = (types => \@EXPORT_OK);

# static method to group surfaces having same surface_type, bridge_angle and thickness*
sub group {
    my $class = shift;
    my $params = ref $_[0] eq 'HASH' ? shift(@_) : {};
    my (@surfaces) = @_;
    
    my %unique_types = ();
    foreach my $surface (@surfaces) {
        my $type = join '_',
            ($params->{merge_solid} && $surface->is_solid) ? 'solid' : $surface->surface_type,
            $surface->bridge_angle // '',
            $surface->thickness // '',
            $surface->thickness_layers;
        $unique_types{$type} ||= [];
        push @{ $unique_types{$type} }, $surface;
    }
    
    return values %unique_types;
}

sub offset {
    my $self = shift;
    return [ map $self->clone(expolygon => $_), @{$self->expolygon->offset_ex(@_)} ];
}

sub p {
    my $self = shift;
    return @{$self->polygons};
}

1;
