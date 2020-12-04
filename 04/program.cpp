#include <fstream>
#include <iostream>

struct passport
{
        bool byr;
        bool iyr;
        bool eyr;
        bool hgt;
        bool hcl;
        bool ecl;
        bool pid;
        bool cid;	// optional
};

static bool
passport_valid(passport &p)
{
        return p.byr && p.iyr && p.eyr && p.hgt && p.hcl && p.ecl && p.pid;
}

int
main(int argc, char *argv[])
{
        std::ifstream f;

        f.open("input.txt", std::ifstream::in);

        int count_valid = 0;
        passport p = passport();
        char buf[100];
        while(f.getline(buf, sizeof buf))
        {
                std::string str = buf;

                if (str.find("byr:") != std::string::npos)
                        p.byr = true;
                if (str.find("iyr:") != std::string::npos)
                        p.iyr = true;
                if (str.find("eyr:") != std::string::npos)
                        p.eyr = true;
                if (str.find("hgt:") != std::string::npos)
                        p.hgt = true;
                if (str.find("hcl:") != std::string::npos)
                        p.hcl = true;
                if (str.find("ecl:") != std::string::npos)
                        p.ecl = true;
                if (str.find("pid:") != std::string::npos)
                        p.pid = true;
                if (str.find("cid:") != std::string::npos)
                        p.cid = true;

                if (str.empty())
                {
                        if (passport_valid(p))
                                count_valid++;
                        p = passport();
                        continue;
                }
        }
        // count the last one
        if (passport_valid(p))
                count_valid++;

        std::cout << count_valid << std::endl;

        return 0;
}
