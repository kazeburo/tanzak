package Tanzak::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use Array::Transpose::Ragged qw/transpose_ragged/;
use Lingua::JA::Regular::Unicode qw/space_h2z katakana_h2z alnum_h2z/;

sub h2z {
    my $text = shift;
    space_h2z(katakana_h2z(alnum_h2z($text)))
}

sub tanzaku {
    my $text = shift;
    $text = h2z($text);
    my $tate = tategaki($text);
    my @tate = split /\n/, $tate;
    my $top;
    my $bottom;
    my $mergin = "┃". ("　" x length($tate[0])) ."┃";
    if ( length($tate[0]) % 2 == 1 ) {
        my $l = "━" x ((length($tate[0]) - 1) / 2);
        $top = "┏".$l."┷".$l."┓";
        $bottom = "┗".$l."━".$l."┛";
    }
    else {
        my $l1 = length($tate[0]) > 1
                ? "━" x ((length($tate[0]) / 2)-1)
                : "";    
        my $l2 = "━" x (length($tate[0]) / 2);
        $top = "┏".$l1."┷".$l2."┓";
        $bottom = "┗".$l1."━".$l2."┛";
    }
    my $tanzaku="$top\n$mergin\n";
    for ( @tate ) {
        chomp;
        $tanzaku .= "┃".$_."┃\n";
    }
    $tanzaku .= "$mergin\n$bottom\n";
    $tanzaku;
}

# Copy from Acme-Tategaki
#my @punc = qw(、 。 ， ．);
sub tategaki {
    my $text = shift;
#    $text =~ s/$_\s?/$_　/g for @punc;
    my @text = split /\s/, $text;
    return _convert_vertical(@text);
}

sub _convert_vertical {
    my @text = @_;
    @text = map { [ split //, $_ ] } @text;
    @text = transpose_ragged( \@text );
    @text = map { [ map {$_ || '　' } @$_ ] } @text;
    @text = map { join '', reverse @$_ } @text;

    for (@text) {
        $_ =~ tr/／‥−－─ー「」→↑←↓＝=,、。〖〗【】…/＼：｜｜｜｜¬∟↓→↑←॥॥︐︑︒︗︘︗︘︙/;
        $_ =~ s/〜/∫ /g;
        $_ =~ s/『/ ┓/g;
        $_ =~ s/』/┗ /g;
        $_ =~ s/［/┌┐/g;
        $_ =~ s/］/└┘/g;
        $_ =~ s/\[/┌┐/g;
        $_ =~ s/\]/└┘/g;
        $_ =~ s/＜/∧ /g;
        $_ =~ s/＞/∨ /g;
        $_ =~ s/</∧ /g;
        $_ =~ s/>/∨ /g;
        $_ =~ s/《/∧ /g;
        $_ =~ s/》/∨ /g;
    }
    # print dump @text;

    return join "\n", @text;
}

get '/' => sub {
    my ( $self, $c )  = @_;
    $c->render('index.tx');
};

router ['GET','POST'] => '/api' => sub {
    my ( $self, $c )  = @_;
    my $result = $c->req->validator([
        'q' => {
            rule => [
                ['NOT_NULL','null']
            ]
        }
    ]);
    $c->render_json({ c => tanzaku($result->valid->get('q')) });
};

1;

