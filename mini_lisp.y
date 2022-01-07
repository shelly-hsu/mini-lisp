%{
    #include<iostream>
    #include<string>
    #include<vector>
    #include<algorithm>
    using namespace std;
    int yylex();
    void yyerror(const char* message) {
        cout << "syntax error\n";
    };
    struct Node{
        string name;
        char data_type;
        int res;
        struct Node *left, *right, *mid; 
        int isDefFun;
    };
    struct table{
            string name;
            int val;
    };

    struct temp_table{
            string name;
            Node *node;
    };

    int isEqu, EquSum, first_flag;    //if statement 要用到的
    int inFun = 0, recur =0,idx;
    vector<table> myDeclare, DecforFun;         //variable for function 
    vector<temp_table> DecExp ,DecId;
    table temp1;
    temp_table temp2;
    Node *funid, *funexp; 
    Node *newNode(Node *left_pointer, Node *right_pointer,char type);
    void traverse(Node *node);
    int Add(Node *node);
    int Mul(Node *node);
    int And(Node *node);
    int Or(Node *node);
    void Equal(Node *node);
    void Bind(Node *n1, Node *n2);
    void error();
    Node* root = NULL;
    int find_table_idx(vector<table> vec, string name);
    int find_temp_table_idx(vector<temp_table> vec, string name);
%}

%union{
    int num,boolVal;
    char *str;
    struct Node *node;
}

%token PRINT_NUM PRINT_BOOL MOD  AND OR NOT DEF FUN IF
%token<boolVal> BOOL_VAL
%token<num> NUMBER;
%token<str> ID;
%type<node> program stmts stmt def_stmt print_stmt exps exp if_exp test_exp then_exp else_exp last_exp
%type<node> plus minus multiply divide modulus greater smaller equal
%type<node> logical_op num_op and_op not_op or_op
%type<node> fun_exp fun_call fun_ids fun_body fun_name param params variable variables
%left NUM
%left '+' '-'
%left '*' '/'  MOD
%left '(' ')'
%%
program: stmts { root = $1;}
        ;
stmts: stmt stmts {$$= newNode($1, $2, 'S');}
    | stmt {$$=$1;}
    ;

stmt: exp {$$=$1;}
    | def_stmt {$$=$1;}
    | print_stmt {$$=$1;}
    ;

print_stmt: '(' PRINT_NUM exp ')' {$$ = newNode($3, NULL, 'P');}
            | '(' PRINT_BOOL exp ')' {$$ = newNode($3, NULL , 'p');}
            ;
exps: exp exps {$$ = newNode($1, $2, 'E');}
    | exp {$$ = $1;}
    ;
exp: BOOL_VAL  {$$ = newNode(NULL, NULL, 'B');
                $$-> res = $1;
            }
    | NUMBER {  $$ = newNode(NULL, NULL, 'N');
                $$ -> res = $1;
            }
    | variable {$$=$1;}
    | num_op {$$=$1;}
    | logical_op {$$=$1;}
    | fun_exp {$$=$1;}
    | fun_call {$$=$1;}
    | if_exp {$$=$1;}
    ;

num_op: plus {$$=$1;}
        | minus {$$=$1;}
        | multiply {$$=$1;}
        | divide {$$=$1;}
        | modulus {$$=$1;}
        | greater {$$=$1;}
        | smaller {$$=$1;}
        | equal {$$=$1;}
        ;
plus: '(' '+' exp exps ')' {$$ = newNode($3, $4, '+');}
        |'(' '+' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '+' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
minus: '(' '-' exp exp ')' {$$ = newNode($3, $4, '-');}
        |'(' '-' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '-' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
divide: '(' '/' exp exp ')' {$$ = newNode($3, $4, '/');}
        |'(' '/' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '/' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
multiply: '(' '*' exp exps ')' {$$ = newNode($3, $4, '*');}
        |'(' '*' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '*' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
    
modulus: '(' MOD exp exp ')' {$$ = newNode($3, $4, '%');}
        |'(' MOD ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' MOD exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
greater: '(' '>' exp exp ')' {$$ = newNode($3, $4, '>');}
        |'(' '>' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '>' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
smaller: '(' '<' exp exp ')' {$$ = newNode($3, $4, '<');}
        |'(' '<' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '<' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
    
equal: '(' '=' exp exps ')' {$$ = newNode($3, $4, '=');}
        |'(' '=' ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' '=' exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
    
logical_op: and_op {$$=$1;}
            | or_op {$$=$1;}
            | not_op {$$=$1;}
            ;
and_op: '(' AND exp exps ')' {$$ = newNode($3, $4, '&');}
        |'(' AND ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' AND exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
        
or_op: '(' OR exp exps ')' {$$ = newNode($3, $4, '|');}
        |'(' OR ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
	|'(' OR exp ')' {cout << "Need 2 arguments, but got 1.\n"; exit(1);}
        ;
not_op: '(' NOT exp')' {$$ = newNode($3, NULL, '~');}
        |'(' NOT ')' {cout << "Need 2 arguments, but got 0.\n"; exit(1);}
        ;

def_stmt: '(' DEF variable exp ')' {    $$ = newNode($3, $4, 'D'); 
                                        $3->res = $4->res;
                                        $$->isDefFun = $4->isDefFun;}
        ;
variables: variable variables {$$ = newNode($1,$2, 'V');}
        |       {$$=newNode(NULL, NULL, 'V');}
        ;
variable: ID {  $$ = newNode(NULL, NULL, 'V');
                $$ -> name = $1;
                }
        ;
fun_exp: '(' FUN fun_ids fun_body ')' {$$ = newNode($3, $4, 'c'); $$->isDefFun = 1;}
        ;
fun_ids: '(' variables ')' {$$ = $2;}
        ;
fun_body: exp {$$ = $1;}
        ;
fun_call: '(' fun_exp params ')'  {$$ = newNode($2, $3, 'c');}
        | '(' fun_name params ')' {$$ = newNode($2, $3, 'C');}
        ;
param: exp {$$ = $1;}
 
params: param params {$$ = newNode($1,$2,'N');}
        |       {$$=newNode(NULL,NULL,'N');}
        ;
last_exp: exp {$$=$1;}
        ;
fun_name: variable {  $$ = newNode($1, NULL, 'n');
                $$ -> name = $1 -> name;
             }
        ;

if_exp: '(' IF test_exp then_exp else_exp ')' { $$ = newNode($3, $5, 'I');
                                                $$ -> mid = $4;
                                        }
        ;
test_exp: exp {$$=$1;}
        ;
then_exp: exp {$$=$1;}
        ;
else_exp: exp {$$=$1;}
        ;
%%

Node *newNode(Node *left_pointer, Node *right_pointer, char type){
    Node *temp = new Node();
    temp->name = "";
    temp -> data_type = type;
    temp -> left = left_pointer;
    temp -> mid = NULL;         //當遇到if statement的時候會用到
    temp -> right = right_pointer;
    temp->isDefFun = 0;
    return temp;
}

void traverse(Node* node){
        if(node == NULL)
                return ;
        switch(node->data_type){
                case '+':               //plus operator
                        traverse(node->left);
                        traverse(node->right);
                        node->res = Add(node);
                        break;
                case '-':               //minus operator
                        traverse(node->left);
                        traverse(node->right);
                        node->res = node->left->res - node->right->res;
                        break;
                case '*':               //multiply operator
                        traverse(node->left);
                        traverse(node->right);
                        node->res=Mul(node);
                        break;
                case '/':               //divide operator
                        traverse(node->left);
                        traverse(node->right);
                        if(node->left != NULL && node->right != NULL){
                                if(node->right->res != 0){
                                        node->res = node->left->res/node->right->res;
                                }
                                else{
                                        error();
                                }
                        }
                        break;
                case '%':               //mod operator
                        traverse(node->left);
                        traverse(node->right);
                         if(node->left != NULL && node->right != NULL){
                                if(node->right->res != 0){
                                        node->res = node->left->res % node->right->res;
                                }
                                else{
                                        error();
                                }
                        }
                        break;
                case '>':                 //greater operator
                        traverse(node->left);
                        traverse(node->right);
                        if(node->left != NULL && node->right != NULL){
                                if(node->left->res > node->right->res)
                                        node->res = 1;
                                else 
                                        node->res = 0;
                        }
                        break;
                case '<':               //smaller operator
                        traverse(node->left);
                        traverse(node->right);
                        if(node->left != NULL && node->right != NULL){
                                if(node->left->res < node->right->res)
                                        node->res = 1;
                                else 
                                        node->res = 0;
                        }
                        break;
                case '=':               //equal operator
                        traverse(node->left);
                        traverse(node->right);
                        first_flag = 0;
                        isEqu = 1;
                        EquSum =0;
                        Equal(node);
                        node->res = isEqu;
                        break;
                case '&':               //and operator
                        traverse(node->left);
                        traverse(node->right);
                        node -> res = And(node);
                        break;
                case '|':               //or operator
                        traverse(node->left);
                        traverse(node->right);
                        node -> res = Or(node);
                        break;
                case '~':               //not operator
                        traverse(node->left);
                        node -> res = !node->left->res;
                        break;
                case 'P':               //print_num
                        traverse(node->left);
                        cout << node->left->res << "\n";
                        inFun = 0;
                        recur =0;
                        for(int i=0;i<DecforFun.size();i++){
                                DecforFun[i].val = 0;
                        }
                        break;
                case 'p':               //PRINT_BOOL
                        traverse(node->left);
                        traverse(node->right);
                        if(node->left->res == 1)
                                cout << "#t\n";
                        else
                                cout << "#f\n";
                        break;
                case 'I':               //if statement
                        traverse(node->left);
                        traverse(node->mid);
                        traverse(node->right);
                        if(node->left->res == 1)
                                node->res = node->mid->res;
                        else
                                node->res = node->right->res;
                        break;
                case 'D':   //DEF variable exp 
                        //cout << "isDefFun: " << node->isDefFun << endl; 
                        if(node->isDefFun == 0){                        //define a variable not funtion
                                //cout << "isDefFun = 0" <<endl;
                                traverse(node->right);                  //traverse exp to get node->right->res 
                                temp1.name = node->left->name;
                                temp1.val = node->right->res;
                                myDeclare.push_back(temp1);             //store the variable
                        }
                        else{
                                //cout << "isDefFun = 1" << node->data_type <<endl;
                                if(node->right->left->left == NULL){      //fun_exp: FUN fun_ids fun_body
                                        //cout << "NULL" << endl;
                                        temp2.name = node->left->name;
                                        temp2.node = node->right->right;
                                        DecExp.push_back(temp2);
                                }
                                else{                                   //fun_call
                                        //cout << "not NULL" << endl;
                                        funid = node->right->left;
                                        funexp = node ->right->right;
                                        temp2.name = node->left->name;
                                        temp2.node = funid;
                                        DecId.push_back(temp2);
                                        temp2.node = funexp;
                                        DecExp.push_back(temp2);
                                        //cout << "DecExp.size(): " <<  DecExp.size() << endl;
                                        //cout << "DecId.size(): " <<  DecId.size() << endl;
                                }
                        }
                        break;
                case 'V':
                        //cout << "node_name:" << node->name << endl;
                        if(inFun == 1){
                                int idx = find_table_idx(DecforFun,node->name);
                                if(idx != -1)
                                        node->res = DecforFun[idx].val;
                        }
                        else{                                           //get teh result for the prarmaeters
                                int idx = find_table_idx(myDeclare,node->name);
                                if(idx != -1)
                                        node->res = myDeclare[idx].val;
                        }
                        break;

                case 'C':                                      //fun_call: fun_name params
                        //cout << "fun_name params" << endl;
                        traverse(node->right);                  //get the function name
                        idx = find_temp_table_idx(DecId, node->left->name);
                        if(idx != -1)
                                Bind(DecId[idx].node, node->right);
                        inFun = 1;
                        idx = find_temp_table_idx(DecExp, node->left->name);
                        if (idx != -1)
                                traverse(DecExp[idx].node);
                        node->res = DecExp[idx].node->res + recur;
                        recur = node->res;
                        break;
                case 'c':                                       //fun_call: fun_exp params
                        //cout << "fun_exp params" << endl;
                        //cout << "node->left->left->name" << node->left->left->name << endl;   //fun_exp FUN fun_ids fun_body
                        Bind(node->left->left, node->right);    //bind id node and param
                        inFun = 1;
                        traverse(node->left->right);    
                        node->res = node->left->right->res;     //the result of fun_body
                        break;
                default:
                        traverse(node->left);
                        traverse(node->right);
                        break;
        
       }

}

//when the rule involve exp exps need function to recursive 
int Add(Node *node){
        int res =0;
        if(node->left != NULL)
                res = res +node->left->res;
        if(node->right != NULL){
                res = res + node->right->res;
                if(node->right->data_type == 'E')
                        res = res + Add(node->right);
        }
        return res;
}
int Mul(Node *node){
        int res = 1;
        if(node->left != NULL)
                res = res*node->left->res;
        if(node->right != NULL){
                if(node->right->data_type == 'E')
                        res *= Mul(node->right);
                else 
                        res *= node->right->res;
        }
        return res;
}
int And(Node *node){
        int res = 1;
        if(node->left != NULL)
                res = res & node->left->res;
        if(node->right != NULL){
                if(node->right->data_type == 'E')
                        res  = res&And(node->right);
                else 
                        res = res&node->right->res;
        }
        return res;
}
int Or(Node *node){
        int res = 0;
        if(node->left != NULL)
                res = res | node->left->res;
        if(node->right != NULL){
                if(node->right->data_type == 'E')
                        res  = res|Or(node->right);
                else 
                        res = res|node->right->res;
        }
        return res;
}

void Equal(Node *node){
        if(node->left != NULL){
                if(first_flag = 0){
                        first_flag = 1;
                        EquSum = node->left->res;
                }
                else{
                        if(node->left->res != EquSum)
                                isEqu = 0;
                }
        }
        if(node->right != NULL){
                if(node->right->data_type == 'E'){
                        Equal(node->right);
                }
                else{
                        if(first_flag == 0){
                                EquSum = node->right->res;
                                first_flag = 0;
                        }
                        else{
                                if(node->left->res != EquSum)
                                        isEqu = 0;
                        }
                }
        }
}

//bind the variable with paramneters
void Bind(Node *n1, Node *n2){
        //cout << "n1_name: " << n1->name <<" "<< "n1_type:"<<n1->data_type << endl;
        //cout << "n2_name: " << n2->name << "n2_type:" <<n2->data_type << endl;
        if(n1 == NULL || n2 == NULL)
                return;
        if(n1->data_type == 'V' && n2->data_type == 'N'){
                //cout << "if" << endl;
                Bind(n1->left,n2->left);
                Bind(n1->right,n2->right);
                if(n1->name != "" && n2!=NULL) {
                        //cout << "push" << endl;
                        table temp;
                        temp.name = n1->name;
                        temp.val = n2->res;
                        DecforFun.push_back(temp);
                }
        }
}

//find the index according to the node name in order to acces the element in vector
int find_table_idx(vector<table> vec, string name){
        //cout << name << endl;
        //cout << "vec_size: " << vec.size() << endl;
        for(int i=0;i<vec.size();i++){
                //cout << "i" << " :" <<vec[i].name << vec[i].name.size()<<endl;
                if(vec[i].name==name){
                        return i;
                }
        }
        return -1;    
}

int find_temp_table_idx(vector<temp_table> vec, string name){
        //cout << name << endl;
        //cout << "vec_size: " << vec.size() << endl;
        for(int i =0;i<vec.size();i++){
                //cout << vec[i].name << endl;
                if(vec[i].name==name)
                        return i;
        }
        return -1;
}

void error(){
        cout << "error\n";
}

int main(){
        yyparse();
        traverse(root);
        return 0;
}


