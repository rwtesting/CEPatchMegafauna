#!/usr/bin/perl
use strict;
use warnings;

use lib "../../_lib";
use RWPatcher::Animals;

#
# Generate patch to make entitiesauria races compatible with Combat Extended, b18.
#

# Get entity tool melee bodyparts from mod source xml
# For each, patch file will be ./<base-dir-name>/<file.xml>
# Source may end with (-REF)?.(txt|xml), which will be replaced with ".xml".
my @SOURCEFILES = qw(
    ../../1055485938/Defs/ThingDefs_Races/Races_Animal_Megafauna.xml
    ../../1055485938/Defs/ThingDefs_Races/Races_Animal_Megafauna_2.xml
);
my $SOURCEMOD = 'Megafauna';  # Only patch if this mod is loaded

# hash of values per animal (using values from a17 MF+CE patch)
# required: dodge, crit (not defined in vanilla)
# optional: bodyShape (else default)
# optional: any/all from @ARMORTYPES
# optional: baseHealthScale
my %PATCHABLES = (
    Arthropleura => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.1,
        ArmorRating_Sharp => 0.13,
	bodyShape         => "QuadrupedLow",
	baseHealthScale   => 4,
    },
    Doedicurus => {
        MeleeDodgeChance  => 0.1,
        MeleeCritChance   => 0.3,
	bodyShape         => "QuadrupedLow",
	baseHealthScale   => 6,
    },
    Entelodont => {
        MeleeDodgeChance  => 0.2,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.1,
        ArmorRating_Sharp => 0.125,
	bodyShape         => "Quadruped",
	baseHealthScale   => 7,
    },
    Gigantopithecus => {
        MeleeDodgeChance  => 0.25,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.14,
        ArmorRating_Sharp => 0.16,
	bodyShape         => "Humanoid",
	baseHealthScale   => 7,
    },
    Paraceratherium => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.76,
        ArmorRating_Blunt => 0.2,
        ArmorRating_Sharp => 0.35,
	bodyShape         => "Birdlike",
	baseHealthScale   => 14,
    },
    Titanis => {
        MeleeDodgeChance  => 0.15,
        MeleeCritChance   => 0.45,
        ArmorRating_Blunt => 0.1,
        ArmorRating_Sharp => 0.13,
	bodyShape         => "Birdlike",
	baseHealthScale   => 5,
    },
    Titanoboa => {
        MeleeDodgeChance  => 0.1,
        MeleeCritChance   => 0.45,
        ArmorRating_Blunt => 0.2,
        ArmorRating_Sharp => 0.18,
	bodyShape         => "Serpentine",
	baseHealthScale   => 7,
    },
    WoolyMammoth => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.8,
        ArmorRating_Blunt => 0.16,
        ArmorRating_Sharp => 0.32,
	bodyShape         => "Quadruped",
	baseHealthScale   => 10,  # WAS a17 8 (but as bear?)
    },
    Elasmotherium => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.8,
        ArmorRating_Blunt => 0.16,
        ArmorRating_Sharp => 0.32,
	bodyShape         => "Quadruped",
	baseHealthScale   => 8,
    },
    Smilodon => {
        MeleeDodgeChance  => 0.3,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Quadruped",
	baseHealthScale   => 8,
    },
    Chalicotherium => {
        MeleeDodgeChance  => 0.12,
        MeleeCritChance   => 0.7,
        ArmorRating_Blunt => 0.14,
        ArmorRating_Sharp => 0.16,
	bodyShape         => "Quadruped",
	baseHealthScale   => 8,
    },
    Megaloceros => {
        MeleeDodgeChance  => 0.12,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Quadruped",
	baseHealthScale   => 8,
    },
    Procoptodon => {
        MeleeDodgeChance  => 0.15,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Birdlike",
	baseHealthScale   => 14,
    },
    Megalania => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.2,
        ArmorRating_Sharp => 0.18,
	bodyShape         => "Serpentine",
	baseHealthScale   => 11,
    },
    Gomphotaria => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.1,
        ArmorRating_Sharp => 0.13,
	bodyShape         => "Serpentine",
	baseHealthScale   => 9,
    },
    Diprotodon => {
        MeleeDodgeChance  => 0.12,
        MeleeCritChance   => 0.7,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Quadruped",
	baseHealthScale   => 7,
    },
    ShortfacedBear => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Quadruped",
	baseHealthScale   => 7.5,
    },
    Dinocrocuta => {
        MeleeDodgeChance  => 0.2,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Quadruped",
	baseHealthScale   => 7,
    },
    Sivatherium => {
        MeleeDodgeChance  => 0.1,
        MeleeCritChance   => 0.45,
        ArmorRating_Blunt => 0.14,
        ArmorRating_Sharp => 0.16,
	bodyShape         => "Quadruped",
	baseHealthScale   => 9,
    },
    Andrewsarchus => {
        MeleeDodgeChance  => 0.2,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.16,
        ArmorRating_Sharp => 0.32,
	bodyShape         => "Quadruped",
	#baseHealthScale   => 7,
    },
    Dinornis => {
        MeleeDodgeChance  => 0.15,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.13,
        ArmorRating_Sharp => 0.15,
	bodyShape         => "Birdlike",
	bodyShape         => "Birdlike",
	#baseHealthScale   => 7.5,
    },
    Macrauchenia => {
        MeleeDodgeChance  => 0.2,
        MeleeCritChance   => 0.5,
        ArmorRating_Blunt => 0.16,
        ArmorRating_Sharp => 0.32,
	bodyShape         => "Quadruped",
	#baseHealthScale   => 5,
    },
    Quinkana => {
        MeleeDodgeChance  => 0.09,
        MeleeCritChance   => 0.4,
        ArmorRating_Blunt => 0.2,
        ArmorRating_Sharp => 0.18,
	bodyShape         => "Serpentine",
	#baseHealthScale   => 5.2,
    },
);

my $patcher;
foreach my $sourcefile (@SOURCEFILES)
{
    $patcher = new RWPatcher::Animals(
        sourcemod  => $SOURCEMOD,
        sourcefile => $sourcefile,
        cedata     => \%PATCHABLES,
    ) or die("ERR: Failed new RWPatcher::Animals: $!\n");

    $patcher->generate_patches();
}

exit(0);

__END__

