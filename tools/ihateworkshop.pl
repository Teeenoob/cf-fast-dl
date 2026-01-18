use strict;
use warnings;
use File::Copy;
use File::Path qw(make_path);
use File::Spec;

my $base_dir = File::Spec->rel2abs('.');
my $destination = File::Spec->catdir($base_dir, 'maps');

unless (-d $destination) {
    make_path($destination) or die "Failed to create folder $destination: $!";
}

sub scan_folder {
    my ($folder) = @_;
    opendir(my $dh, $folder) or return;

    while (my $entry = readdir($dh)) {
        next if $entry =~ /^\./;
        next if $entry eq 'maps';

        my $path = File::Spec->catfile($folder, $entry);
        if (-d $path) {
            scan_folder($path);
        } elsif ($entry =~ /\.bsp$/i) {
            copy_file($path);
        }
    }
    closedir($dh);
}

sub copy_file {
    my ($source) = @_;
    my $filename = (File::Spec->splitpath($source))[2];
    my $dest = File::Spec->catfile($destination, $filename);

    my $count = 1;
    while (-e $dest) {
        $dest = File::Spec->catfile($destination, $filename =~ s/(\.bsp)$/_$count$1/r);
        $count++;
    }

    copy($source, $dest) or warn "Failed to copy $source: $!";
    print "Copied $source -> $dest\n";
}

scan_folder($base_dir);

print "\nAll BSP files copied to $destination\n";
