requires 'Cot';
requires 'YAML';
requires 'Digest::SHA1';
requires 'parent';

on test => sub {
    requires 'Test::More', 0.98;
    requires 'Cot';
};

on configure => sub {
};

on 'develop' => sub {
};
