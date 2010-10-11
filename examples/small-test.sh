# This is for quickly checking to see that the basic shash functions are working

. ./shash.sh

echo "shash Implementations:"
shash_implementation

echo "Dogs:"
shash dogs

shash dogs Snoopy Beagle

echo "Dogs:"
shash dogs

shash dogs Rover "Golden Retriever"

echo "Dogs:"
shash dogs

echo "Rover is a:"
shash dogs Rover
