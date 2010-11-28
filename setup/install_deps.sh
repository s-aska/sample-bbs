#!/bin/bash
cat <<EOF | cpanm
Plack
Plack::Session
Starman
DBIx::Skinny
DBIx::Skinny::InflateColumn::DateTime
Digest::SHA
FormValidator::Simple
HTML::FillInForm::Lite
Log::Minimal
File::Stamped
Text::Xslate
DBD::Pg
EOF
