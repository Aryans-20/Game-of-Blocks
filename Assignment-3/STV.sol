// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Implementaion of Single Transferable Vote
contract Ballot {
   
    struct Voter {
        bool voted;  // if true, that person already voted
        uint[] vote;   // index of the voted proposal
        bool exists;
        bool is_candidate;
    }
    struct Proposal {
        string name;   
        address[] support;
        uint[] support_weight;
        uint[] liking;
        uint in_support;        //Number of votes in currently running round
    }
    constructor(){
        chairperson=msg.sender;
    }
    address public chairperson;
    mapping(address=>Voter) public voters;         //a mapping from address to voters
    uint[] public elim;                            //list of candidates eliminated
    bool public can_vote=bool(false);
    bool public can_register_candidate=bool(false);
    bool public can_register_voter=bool(false);
    uint public cand_num=0;
    uint public voter_num=0;
    uint public liking_temp;
    uint public vote_vector_temp;
    address public support_temp;
    function check_liking(uint al,uint be) public{
        liking_temp=proposals[al].liking[be];
    }
    function check_vote_vector(address al,uint be) public{
        vote_vector_temp=voters[al].vote[be];
    }
    function check_support(uint al,uint be) public{
        support_temp=proposals[al].support[be];
    }
    modifier isChairPerson(){
        require(msg.sender==chairperson);
        _;
    }
    function toggle_can_vote() isChairPerson public{
        can_vote=!can_vote;
    }
    function toggle_can_register_voter() isChairPerson public{
        can_register_voter=!can_register_voter;
    }
    function toggle_can_register_candidate() isChairPerson public{
        can_register_candidate=!can_register_candidate;
    }
    uint public num_seat;
    function set_num_seat(uint num_seats) isChairPerson public{
        num_seat=num_seats;
    }
    function Register_Voter() public{
        if((can_register_voter)&&(!voters[msg.sender].exists)){
        voters[msg.sender].voted=false;
        voters[msg.sender].exists=true;
        }
    }
    Proposal[] public proposals;
    function Register_Candidate(string memory Name) public{
        if((can_register_candidate)&&(voters[msg.sender].exists)&&(!voters[msg.sender].is_candidate)){
            uint i;
            for(i=0;i<proposals.length;i++){
                proposals[i].liking.push(0);
            }
            Proposal memory temp;
            temp.name=Name;
            voters[msg.sender].is_candidate=true;
            cand_num+=1;
            proposals.push(temp);
            for(i=0;i<proposals.length;i++){
                proposals[cand_num-1].liking.push(0);
            }
        }
    }
    function vote(uint[] memory pref) public {
        if((can_vote)&&(voters[msg.sender].exists)&&(!voters[msg.sender].voted)){
        uint i;
        voters[msg.sender].voted=true;
        voters[msg.sender].vote=pref;
        if(pref.length!=0)
        {
            proposals[pref[0]].support.push(msg.sender);
            proposals[pref[0]].in_support+=(10**10);
            voter_num+=1;
            proposals[pref[0]].support_weight.push(10**10);        
        }
        for(i=0;i<pref.length;i++){
            proposals[pref[i]].liking[i]+=1;
        }}
    }
    function check_elim(uint x) public returns(bool f){                //to check if a number is an element of elim
        uint i;
        for(i=0;i<elim.length;i++){
            if(elim[i]==x)
            return true;
        }
        return false;
    }
     uint[] min;                                                    //an array that keeps the list of candidates with least support
     uint[] empt;                                                   //an empty array to clear min when required
    uint[] tempora;
     uint[] public winners;
    function compare_index(uint a1,uint a2) private returns(uint p){        //to compare between 2 indices and eliminate
        uint i;
        for(i=0;i<proposals[min[a1]].liking.length;i++){
            if(proposals[min[a1]].liking[i]>proposals[min[a2]].liking[i])
            return a2;
            else if(proposals[min[a1]].liking[i]<proposals[min[a2]].liking[i])
            return a1;
            else
            continue;
        }
        return a1;                                                  //Could not find anything for randomness
    }
    function tie_breaker() public returns(uint ind1){
        if(min.length>1){
            uint i;
            uint ind;
            ind=0;
            for(i=1;i<min.length;i++){
                ind=compare_index(ind,i);
            }
            return ind;
        }
    }           //to find which candidate to eliminate in case of a tie
    function winningProposal() public{
        uint i;
        uint k;
        uint tempor;
        uint max;
        uint max_val;        //max number of votes held by a candidate
        uint min_val;        //minimum number of votes held by a candidate  
       /* min_val=proposals[0].in_support;*/
        max_val=proposals[0].in_support;
        /*min.push(0);*/
        max=0;
        for(i=0;i<cand_num;i++){
            if(proposals[i].in_support>max_val){
                max_val=proposals[i].in_support;
                max=i;
            }
           /* if(proposals[i].in_support==min_val){
                min.push(i);
            }
            if(proposals[i].in_support<min_val){
                min_val=proposals[i].in_support;
                min=uint[](empt);
                min.push(i);
            }*/
        }
 /*       if(min.length>1)
        {tempor=min[tie_breaker()];
        min=empt;
        min.push(tempor);
        elim.push(tempor);}
        else if(min.length!=0){
            tempor=min[0];
            elim.push(tempor);
        }*/
        while(winners.length!=num_seat){
          while((max_val)>=(((voter_num/(num_seat+1))+1)*(10**10))){
            uint surplus;
            surplus=max_val-(((voter_num/(num_seat+1))+1)*(10**10));
            winners.push(max);
            elim.push(max);
            if(winners.length==num_seat)
            break;
            if(surplus!=0)
            {for(i=0;i<proposals[max].support.length;i++)
            {
                //proposals[max].in_support=(((voter_num/(num_seat+1))+1)*(10**10));
                //voters[proposals[max].support[i]].weightage=((voters[proposals[max].support[i]].weightage*surplus)/max_val);
                for(k=0;(k<voters[proposals[max].support[i]].vote.length);k++){
                        if(!(check_elim(voters[proposals[max].support[i]].vote[k]))){
                            proposals[voters[proposals[max].support[i]].vote[k]].in_support+=((proposals[max].support_weight[i]*surplus)/max_val);
                            proposals[voters[proposals[max].support[i]].vote[k]].support.push(proposals[max].support[i]);
                            proposals[voters[proposals[max].support[i]].vote[k]].support_weight.push(((proposals[max].support_weight[i]*surplus)/max_val));
                            break;
                        }
                }
                if((k==voters[proposals[max].support[i]].vote.length)&&(elim.length<cand_num)){
                        tempora=empt;
                        for(k=0;k<cand_num;k++)
                        {
                            if(!check_elim(k)){
                                tempora.push(k);
                            }
                        }
                        for(k=0;k<tempora.length;k++){
                            proposals[tempora[k]].in_support+=((proposals[max].support_weight[i]*surplus)/(max_val*tempora.length));
                            proposals[tempora[k]].support.push(proposals[max].support[i]);
                            proposals[tempora[k]].support_weight.push(((proposals[max].support_weight[i]*surplus)/(max_val*tempora.length)));
                        }
                }
            }}
            max_val=0;
            for(i=0;i<cand_num;i++){
                if(!check_elim(i)){
                    if(proposals[i].in_support>max_val)
                    max_val=proposals[i].in_support;
                    max=i;
                }
            }
        }
        if(winners.length==num_seat)
        break;
        min=empt;
        for(i=0;i<cand_num;i++){
            if(!check_elim(i))
            {max_val=proposals[i].in_support;
            max=i;
            if((cand_num-elim.length)>(num_seat-winners.length)){
                min_val=proposals[i].in_support;
                min.push(i);}
            break;}
        }
        for(i=0;i<cand_num;i++){
            if(!check_elim(i)){
            if(proposals[i].in_support>max_val){
                max_val=proposals[i].in_support;
                max=i;
            }
            if((cand_num-elim.length)>(num_seat-winners.length)){
                if(proposals[i].in_support==min_val){
                min.push(i);
            }
            if(proposals[i].in_support<min_val){
                min_val=proposals[i].in_support;
                min=uint[](empt);
                min.push(i);
            }}
            else
            {
                tempora=empt;
                for(i=0;i<cand_num;i++){
                    if(!check_elim(i))
                    tempora.push(i);
                }
                for(i=0;i<tempora.length;i++){
                    winners.push(tempora[i]);
                }
                break;
                
            }
        }
        }
        if(min.length>1)
        {tempor=min[tie_breaker()];
        min=empt;
        elim.push(tempor);}
        else if(min.length==1){
            tempor=min[0];
            elim.push(tempor);
            min=empt;
        }
        for(i=0;i<proposals[tempor].support.length;i++){
            for(k=0;k<voters[proposals[tempor].support[i]].vote.length;k++){
                if(!check_elim(voters[proposals[tempor].support[i]].vote[k])){
                    proposals[voters[proposals[tempor].support[i]].vote[k]].in_support+=proposals[tempor].support_weight[i];
                    proposals[voters[proposals[tempor].support[i]].vote[k]].support.push(proposals[tempor].support[i]);
                    proposals[voters[proposals[tempor].support[i]].vote[k]].support_weight.push(proposals[tempor].support_weight[i]);
                    break;
                }
            }
            if((k==voters[proposals[tempor].support[i]].vote.length)&&(elim.length<cand_num)){
                        tempora=empt;
                        for(k=0;k<cand_num;k++)
                        {
                            if(!check_elim(k)){
                                tempora.push(k);
                            }
                        }
                        for(k=0;k<tempora.length;k++){
                            proposals[tempora[k]].in_support+=(proposals[tempor].support_weight[i]/tempora.length);
                            proposals[tempora[k]].support.push(proposals[tempor].support[i]);
                            proposals[tempora[k]].support_weight.push((proposals[tempor].support_weight[i]/tempora.length));
                        }
                }
        }
        }
    }
}
