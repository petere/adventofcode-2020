#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main(int argc, char *argv[])
{
	FILE *f = fopen(argv[1], "r");
	if (!f)
	{
		perror(argv[0]);
		exit(1);
	}

	int valid = 0;
	int valid2 = 0;

	char buf[100];
	for (;;)
	{
		if (!fgets(buf, sizeof(buf), f))
		{
			if (feof(f))
				break;
			perror(argv[0]);
			exit(1);
		}

		if (buf[strlen(buf) - 1] != '\n')
		{
			fprintf(stderr, "line too long\n");
			exit(1);
		}

		int min, max;
		char c;
		char str[100];
		if (sscanf(buf, "%d-%d %c: %s", &min, &max, &c, str) != 4)
		{
			fprintf(stderr, "parse error\n");
			exit(1);
		}

		int count = 0;
		for (char *p = str; *p; p++)
		{
			if (*p == c)
				count++;
		}

		if (count >= min && count <= max)
			valid++;

		/* part 2 */
		int first = min;
		int second = max;
		if (first <= strlen(str) && second <= strlen(str))
		{
			if ((str[first-1] == c && str[second-1] != c)
			    || (str[first-1] != c && str[second-1] == c))
				valid2++;
		}
	}

	printf("%d\n", valid);
	printf("%d\n", valid2);

	return 0;
}
