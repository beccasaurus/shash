. ./shash.sh

shash_define dogs

dogs Snoopy     Beagle
dogs Scooby-Doo "Great Dane"
dogs Lady       "Cocker Spaniel"
dogs Tramp      Mutt

echo ">> dogs Snoopy"
dogs Snoopy
echo ""

echo ">> dogs_keys"
dogs_keys
echo ""

echo ">> dogs_values"
dogs_values
echo ""

echo ">> dogs"
dogs
echo ""

echo ">> dogs_echo 'The dog named \$key is a \$value'"
dogs_echo 'The dog named $key is a $value'
echo ""

echo 'for key in `dog_keys`; do echo "$key is a `dogs "$key"`"; done'
for key in `dogs_keys`; do echo "$key is a `dogs "$key"`"; done
