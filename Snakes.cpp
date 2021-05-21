#include<bits/stdc++.h>
using namespace std;
int main()
{
    class Player
    {
        private:
        string name;
        public:
        int position;
        void assig(string a,int b)
        {
            position=b;
            name=a;
        }
        void play()
        {
            cout<<name<<", enter a number: ";
            int faltu,i;
            string alpha;
            cin>>alpha;
            faltu=1+rand()%6;
            if(faltu==6)
            faltu=faltu+1+rand()%6;
            if(faltu==12)
            faltu=faltu+1+rand()%6;
            int num1,num2;
            num1=faltu/6;
            num2=faltu%6;
            if(num1==3)
            cout<<"You threw 3 sixes in a row.You don't get to move.\n";
            else
            {
                position=position+faltu;
                if(position>100)
                {position=position-faltu;cout<<"Sorry, You can't move\n";}
                else
                {
                    cout<<"You threw a ";
                    for(i=0;i<num1;i++)
                    cout<<"6, ";
                    cout<<num2<<"\nYou have advanced to "<<position<<"\n";
                }
            }
            if(find(ladder_start.begin(),ladder_start.end(),position)!=ladder_start.end())
            {
                cout<<"Congratulations!! You climbed a Ladder\n";
                position=ladder_end[find(ladder_start.begin(),ladder_start.end(),position)-ladder_start.begin()];
                cout<<"You have advanced to "<<position<<"\n";
                cout<<"Let's Celebrate.You get another chance\n";
                play();
            }
            else if(find(snake_start.begin(),snake_start.end(),position)!=snake_start.end())
            {
                cout<<"Alas! You were bitten by a snake\n";
                position=snake_end[find(snake_start.begin(),snake_start.end(),position)-snake_start.begin()];
                cout<<"You have receded to "<<position<<"\n";
            }
        }
        void give_name()
        {cout<<name;}
        int win()
        {
            if(position==100)
            return 1;
            else return 0;
        }
        vector<int> snake_start={30,55,67,62,87,99};
        vector<int> snake_end={15,21,23,50,13,5};
        vector<int> ladder_start={3,10,25,41,56,70,84,};
        vector<int> ladder_end={22,43,69,81,77,95,93};
    };
    srand(time(0));
    cout<<"Welcome to Snakes and Ladders \n";
    cout<<"Enter the number of players \n";
    int j,n,k;
    string b;
    cin>>n;
    Player p[n];
    for(j=0;j<n;j++)
    {
        cout<<"Player "<<j+1<<" Enter your name: \n";
        cin>>b;
        p[j].assig(b,1);
    }
    j=0;
    while(1)
    {
        p[j].play();
        if(p[j].win())
        {
            cout<<"Yippee!! ";
            p[j].give_name();
            cout<<" wins.\n";
            cout<<"Good Game. Cheers";
            return 0;
        }
        for(k=0;k<n;k++)
        {
            if((p[j].position==p[k].position)&&(j!=k))
            {
                cout<<"Sorry ";
                p[k].give_name();
                cout<<" ";
                p[j].give_name();
                p[k].position=1;
                cout<<" stepped on you. You are being sent to Postion 1.\n";
            }
        }
        j=(j+1)%n;
    }
    return 0;
}