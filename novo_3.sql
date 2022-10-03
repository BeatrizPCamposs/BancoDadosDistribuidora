
create database db_distribuidora;


use db_distribuidora;

create table tbUF (
 IdUF int auto_increment primary key,
 UF char(2) unique
);

create table tbBairro (
 IdBairro int auto_increment primary key,
 Bairro varchar(200)
);

create table tbCidade (
 IdCidade int auto_increment primary key,
 Cidade varchar(200)
);

create table tbEndereco (
 CEP decimal(8,0) primary key,
 Logradouro varchar(200),
 IdBairro int,
 foreign key (IdBairro) references tbBairro(IdBairro),
 IdCidade int,
 foreign key (IdCidade) references tbCidade(IdCidade),
 IdUF int,
 foreign key (IdUF) references tbUF(IdUF)
);
create table tbCliente (
 Id int primary key auto_increment,
 NomeCli varchar(50) not null,
 CEP decimal(8,0) not null,
 NumEnd decimal(6,0) not null,
 CompEnd varchar(50),
 foreign key (CEP) references tbEndereco(CEP)
);
create table tbClientePF (
 IdCliente int auto_increment,
 foreign key (IdCliente) references tbCliente(Id),
 Cpf decimal(11,0) not null primary key,
 Rg decimal(8,0),
 RgDig char(1),
 Nasc date
);
create table tbClientePJ (
 IdCliente int auto_increment,
 foreign key (IdCliente) references tbCliente(Id),
 Cnpj decimal(14,0) not null primary key,
 Ie decimal(11,0)
);
create table tbNotaFiscal (
 NF int primary key,
 TotalNota decimal(7, 2) not null,
 DataEmissao date not null
);
create table tbFornecedor (
 Codigo int primary key auto_increment,
 Cnpj decimal(14,0) unique not null,
 Nome varchar(200) not null,
 Telefone decimal(11,0)
);
create table tbCompra (
 NotaFiscal int primary key,
 DataCompra date not null,
 ValorTotal decimal(8, 2) not null,
 QtdTotal int not null,
 Cod_Fornecedor int,
 foreign key (Cod_Fornecedor) references tbFornecedor(Codigo)
);
create table tbProduto (
 CodBarras decimal(14,0) primary key,
 Qtd int,
 Nome varchar(200) not null,
 ValorUnitario decimal(6, 2) not null
);
create table tbItemCompra (
 Qtd int not null,
 ValorItem decimal(6, 2) not null,
 NotaFiscal int,
 CodBarras decimal(14,0),
 primary key (NotaFiscal, CodBarras),
 foreign key (NotaFiscal) references tbCompra(NotaFiscal),
 foreign key (CodBarras) references tbProduto(CodBarras)
);
create table tbVenda (
 IdCliente int not null,
 foreign key (IdCliente) references tbCliente(Id),
 NumeroVenda int primary key,
 DataVenda datetime not null default(current_timestamp()),
 TotalVenda decimal(7, 2) not null,
 NotaFiscal int,
 foreign key (NotaFiscal) references tbNotaFiscal(NF)
);
create table tbItemVenda (
 NumeroVenda int,
 CodBarras decimal(14,0),
 primary key (NumeroVenda, CodBarras),
 foreign key (NumeroVenda) references tbVenda(NumeroVenda),
 foreign key (CodBarras) references tbProduto(CodBarras),
 Qtd int not null,
 ValorItem decimal(6, 2) not null
);
-- Ex 1
delimiter $$
create procedure spInsertForn(vNome varchar(200), vCNPJ decimal(14,0), vTelefone decimal(11,0))
begin
insert into tbFornecedor(Nome, CNPJ, Telefone) values (vNome, vCNPJ, vTelefone);
end $$
call spInsertForn('Revenda Chico Loco', 1245678937123, 11934567897);
call spInsertForn('José Faz Tudo S/A', 1345678937123, 11934567898);
call spInsertForn('Vadalto Entregas', 1445678937123, 11934567899);
call spInsertForn('Astrogildo das Estrela', 1545678937123, 11934567800);
call spInsertForn('Amoroso e Doce', 1645678937123, 11934567801);
call spInsertForn('Marcelo Dedal', 1745678937123, 11934567802);
call spInsertForn('Franciscano Cachaça', 1845678937123, 11934567803);
call spInsertForn('Joãozinho Chupeta', 1945678937123, 11934567804);
-- EX 2
delimiter $$
create procedure spInsertCidade(vCidade varchar(200))
begin
if not exists (select IdCidade from tbCidade where Cidade = vCidade) then
	insert into tbCidade(Cidade) values (vCidade);
end if;
end $$
call spInsertCidade('Rio de Janeiro');
call spInsertCidade('São Carlos');
call spInsertCidade('Campinas');
call spInsertCidade('Franco da Rocha');
call spInsertCidade('Osasco');
call spInsertCidade('Pirituba');
call spInsertCidade('Lapa');
call spInsertCidade('Ponta Grossa');
-- EX 3
delimiter $$
create procedure spInsertUF(vUF char(2))
begin
if not exists (select IdUf from tbUF where UF = vUF) then
	insert into tbUF(UF) values (vUF);
end if;
end $$
call spInsertUF('SP');
call spInsertUF('RJ');
call spInsertUF('RS');
-- EX 4
delimiter $$
create procedure spInsertBairro(vBairro varchar(200))
begin
if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
	insert into tbBairro(Bairro) values (vBairro);
end if;
end $$
call spInsertBairro('Aclimação');
call spInsertBairro('Capão Redondo');
call spInsertBairro('Pirituba');
call spInsertBairro('Liberdade');
-- EX 5
delimiter $$
create procedure spInsertProduto(vCodBarras decimal(14,0), vNome varchar(200), vValorUnitario decimal(6, 2), vQtd int)
begin
	insert into tbProduto(CodBarras, Nome, ValorUnitario, Qtd) values (vCodBarras, vNome, vValorUnitario, vQtd); 
end $$

call spInsertProduto('12345678910111', 'Rei de Papel Mache', '54.61', '120');
select * from tbproduto;
call spInsertProduto('12345678910112', 'Bolinha de Sabão', '100.45', '120');
call spInsertProduto('12345678910113', 'Carro Bate Bate', '44.00', '120');
call spInsertProduto('12345678910114', 'Bola Furada', '10.00', '120');
call spInsertProduto('12345678910115', 'Maçã Laranja', '99.44', '120');
call spInsertProduto('12345678910116', 'Boneco do Hitler', '124.00', '200');
call spInsertProduto('12345678910117', 'Farinha de Suruí', '50.00', '200');
call spInsertProduto('12345678910118', 'Zelador de Cemitério', '24.50', '100');
-- EX 6
delimiter $$
create procedure spInsertEndereco(vCEP decimal(8,0), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
if not exists (select CEP from tbEndereco where CEP = vCEP) then
	if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
		insert into tbBairro(Bairro) values (vBairro);
	end if;
	if not exists (select IdUf from tbUF where UF = vUF) then
		insert into tbUF(UF) values (vUF);
	end if;
	if not exists (select IdCidade from tbCidade where Cidade = vCidade) then
		insert into tbCidade(Cidade) values (vCidade);
	end if;
	set @IdBairro = (select IdBairro from tbBairro where Bairro = vBairro);
	set @IdUf = (select IdUF from tbUF where UF = vUf);
	set @IdCidade = (select IdCidade from tbCidade where Cidade = vCidade);
	insert into tbEndereco(CEP, Logradouro, IdBairro, IdCidade, IdUF) values
	(vCEP, vLogradouro, @IdBairro, @IdCidade, @IdUF); 
end if;
end $$
call spInsertEndereco(12345050, 'Rua da Federal', 'Lapa', 'São Paulo', 'SP');
call spInsertEndereco(12345051, 'Av Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertEndereco(12345052, 'Rua Liberdade', 'Consolação', 'São Paulo', 'SP');
call spInsertEndereco(12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertEndereco(12345054, 'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertEndereco(12345055, 'Rua Piu XI', 'Penha', 'Campina', 'SP');
call spInsertEndereco(12345056, 'Rua Chocolate', 'Aclimação', 'Barra Mansa', 'RJ');
call spInsertEndereco(12345057, 'Rua Pão na Chapa', 'Barra Funda', 'Ponto Grossa', 'RS');
-- EX 7
delimiter $$
create procedure spInsertCliente (vNome varchar(50), vNumEnd decimal(6,0), vCompEnd varchar(50), vCEP decimal(8,0), vCPF decimal(11,0), vRG decimal(8,0), vRgDig char(1), vNasc date,
vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
   	if not exists (select CPF from tbClientePF where CPF = vCPF) then
		if not exists (select CEP from tbEndereco where CEP = vCEP) then
			if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
				insert into tbBairro(Bairro) values (vBairro);
			end if;
			if not exists (select IdUf from tbUF where UF = vUF) then
				insert into tbUF(UF) values (vUF);
			end if;
			if not exists (select IdCidade from tbCidade where Cidade = vCidade) then
				insert into tbCidade(Cidade) values (vCidade);
			end if;
			set @IdBairro = (select IdBairro from tbBairro where Bairro = vBairro);
			set @IdUf = (select IdUF from tbUF where UF = vUf);
			set @IdCidade = (select IdCidade from tbCidade where Cidade = vCidade);
			insert into tbEndereco(CEP, Logradouro, IdBairro, IdCidade, IdUF) values
			(vCEP, vLogradouro, @IdBairro, @IdCidade, @IdUF); 
		end if;
		insert into tbCliente(NomeCli, CEP, NumEnd, CompEnd) values (vNome, vCEP, vNumEnd, vCompEnd);
		insert into tbClientePF(CPF, RG, RgDig, Nasc) values (vCPF, vRG, vRgDig, vNasc);
	else
		select "Existe";
	end if;
end $$
call spInsertCliente('Pimpão', 325, null, 12345051, 12345678911, 12345678, 0, '2000-12-10', 'Av. Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertCliente('Disney Chaplin', 89, 'Ap. 12', 12345053, 12345678912, 12345679, 0, '2001-11-21', 'Av. Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliente('Marciano', 744, null, 12345054, 12345678913, 12345680, 0, '2001-06-01', 'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliente('Lança Perfume', 128, null, 12345059, 12345678914, 12345681, 'X', '2004-04-05', 'Rua Veia', 'Jardim Santa Isabel', 'Cuiabá', 'MT');
call spInsertCliente('Remédio Amargo', 2485, null, 12345058, 12345678915, 12345682, 0, '2002-07-15', 'Av. Nova', 'Jardim Santa Isabel', 'Cuiabá', 'MT');
-- EX 8 
delimiter $$
create procedure spInsertCliPJ (vNome varchar(50), vCNPJ decimal(14,0), vIE decimal(11,0), vCEP decimal(8,0), vLogradouro varchar(200), vNumEnd decimal(6,0), vCompEnd varchar(50),
vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
    if not exists (select Cnpj from tbClientePJ where Cnpj = vCNPJ) then
		if not exists (select CEP from tbEndereco where CEP = vCEP) then
			if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
				insert into tbBairro(Bairro) values (vBairro);
			end if;
			if not exists (select IdUf from tbUF where UF = vUF) then
				insert into tbUF(UF) values (vUF);
			end if;
			if not exists (select IdCidade from tbCidade where Cidade = vCidade) then
				insert into tbCidade(Cidade) values (vCidade);
			end if;
			set @IdBairro = (select IdBairro from tbBairro where Bairro = vBairro);
			set @IdUf = (select IdUF from tbUF where UF = vUf);
			set @IdCidade = (select IdCidade from tbCidade where Cidade = vCidade);
			insert into tbEndereco(CEP, Logradouro, IdBairro, IdCidade, IdUF) values
			(vCEP, vLogradouro, @IdBairro, @IdCidade, @IdUF); 
		end if;
			insert into tbCliente(NomeCli, CEP, NumEnd, CompEnd) value(vNome, vCEP, vNumEnd, vCompEnd);
			insert into tbClientePJ(Cnpj, Ie) value (vCNPJ, vIE);
	else
		select "Existe";
	end if;
end $$
call spInsertCliPJ('Paganada', 12345678912345, 98765432198, 12345051, 'Av. Brasil', 159, null, 'Lapa', 'Campinas', 'SP');
call spInsertCliPJ('Caloteando', 12345678912346, 98765432199, 12345053, 'Av. Paulista', 69, null, 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliPJ('Semgrana', 12345678912347, 98765432100, 12345060, 'Rua dos Amores', 189, null, 'Sei Lá', 'Recife', 'PE');
call spInsertCliPJ('Cemreais', 12345678912348, 98765432101, 12345060, 'Rua dos Amores', 5024, 'Sala 23', 'Sei Lá', 'Recife', 'PE');
call spInsertCliPJ('Durango', 12345678912349, 98765432102, 12345060, 'Rua dos Amores', 1254, null, 'Sei Lá', 'Recife', 'PE');

-- EX 9

delimiter $$

create procedure spInsertCompra(vNotaFiscal int,vFornecedor varchar(100), vDataCompra date, vCodigoBarras decimal(14,0), vValorItem decimal(5,2), vQtd int,vQtdTotal int,vValorTotal decimal(10,2))

begin

	if not exists(select * from tbCompra where NotaFiscal = vNotaFiscal) then

        set @Fornecedor = (select codigo from tbFornecedor where nome = vFornecedor);

		insert into tbCompra(NotaFiscal,DataCompra,ValorTotal,QtdTotal,Cod_Fornecedor) values (vNotaFiscal,vDataCompra,vValorTotal,vQtdTotal,@Fornecedor);

    end if;    

    insert into tbitemcompra(NotaFiscal,CodBarras,Qtd,ValorItem) values (vNotaFiscal,vCodigoBarras,vQtd,vValorItem);

end

$$

call spInsertCompra(8459,"Amoroso e Doce",'2018-05-01',12345678910111,22.22,200,700, 21944.00);

call spInsertCompra(2482,"Revenda Chico Loco",'2020-04-22',12345678910112,40.50,180,180,7290.00);

call spInsertCompra(21653,"Marcelo Dedal",'2020-07-12',12345678910113,3.00,300,300,900.00);

call spInsertCompra(8459,"Amoroso e Doce",'2020-12-04',12345678910114,35.00,500,700,21944.00);

select * from tbcompra;

call spInsertCompra(156354,"Revenda Chico Loco",'2021-11-23',12345678910115,54.00,350,350,18900.00);

select * from tbitemvenda;

-- EX 10 

delimiter $$

create procedure spInsertVenda(vCodigoVenda int,vCliente varchar(100), vDataVenda char(10), vCodigoBarras decimal(14,0), vValorItem decimal(5,2), vQtd int,vTotalVenda decimal (10,2), vNotaFiscal int)

create procedure spInsertVenda(vCliente varchar(100), vCodigoBarras decimal(14,0), vValorItem decimal(5,2), vQtd int, vNotaFiscal int)

begin

	if exists (select * from tbProduto, tbCliente where CodBarras = vCodigoBarras and NomeCli = vCliente) then

		if not exists(select * from tbVenda where NumeroVenda = vCodigoVenda) then

			set @dataVenda = str_to_date(date.current_timestamp(), '%Y-%m-%d');

			set @idCliente = (select Id from tbCliente where NomeCli = vCliente);
            
            set @totalvenda = (vValorItem * vQtd);

			insert into tbVenda(NumeroVenda,IdCliente,DatbitemcomprataVenda,TotalVenda,NotaFiscal) values (default,@idCliente,@dataVenda,@totalvenda,vNotaFiscal);

		end if;

		insert into tbItemVenda(NumeroVenda,CodBarras,ValorItem,Qtd) values (vCodigoVenda,vCodigoBarras,vValorItem,vQtd);

    end if;

	if not exists(select * from tbCliente where NomeCli = vCliente) then 

		select "não Existe esse cliente";

 end if;

	if not exists(select * from tbProduto where CodBarras = vCodigoBarras) then 		

    select "não Existe esse produto";

 end if;

end

$$

call spInsertVenda(1,"Pimpão","22-08-2022",12345678910111,54.61,1,54.61,null);

call spInsertVenda(2,"Lança Perfume","22-08-2022",12345678910112,54.61,1,54.61,null);

call spInsertVenda(3,"Pimpão","22-08-2022",12345678910113,100.45,2,200.90,null);

select * from tbproduto;

-- EX 11

delimiter $$

create procedure spInsertNotaFiscal(vNotaFiscal int, vCliente varchar(100), vDataEmissao char(10))

begin

    set @dataEmissao = str_to_date(vDataEmissao, "%Y-%m-%d");

    set @idCliente = (select id from tbCliente where NomeCli = vCliente);

    set @totalVenda = (select sum(TotalVenda) from tbVenda where idCliente = @idCliente);

    insert into tbNotaFiscal(NF,TotalNota,DataEmissao) values (vNotaFiscal,@totalVenda,@dataEmissao);

    update tbvenda set NotaFiscal = vNotaFiscal where IdCliente = @idCliente;

end

$$

call spInsertNotaFiscal(359,"Pimpão","29-08-2022");
call spInsertNotaFiscal(360,"Lança Perfume","29-08-2022");

select * from tbnotafiscal;


-- Ex 12
call spInsertProduto('12345678910130', "Camiseta de Poliéster", 35.61, 100);
call spInsertProduto('12345678910131', "Blusa Frio Moletom", 200.00, 100);
call spInsertProduto('12345678910132', "Vestido Decote Redondo", 144.00, 50);

-- Fim 12

-- Ex 13

select * from tbproduto;

delete from tbproduto where codbarras = "12345678910116";
delete from tbproduto where codbarras = "12345678910117";

-- Fim 13

-- Ex 14

delimiter $$
create procedure spUpdateProduto(vcodbarras decimal(14,0), vnome varchar(200), vvalorunitario decimal(6,2))
begin
	if exists (select * from tbproduto where codbarras = vcodbarras) then
		update tbproduto  set nome = vnome, valorunitario = vvalorunitario where codbarras = vcodbarras;
	end if;
end $$


call spUpdateProduto('12345678910111', "Rei de Papel Mache", 64.50);
call spUpdateProduto('12345678910112', "Bolinha de Sabão", 120.00);
call spUpdateProduto('12345678910113', "Carro Bate Bate", 64.00);

select * from tbproduto;

-- Fim 14

-- Ex 15

delimiter $$
create procedure spSelectProduto()
begin
	select * from tbproduto;
end $$

call spSelectProduto();

/*
drop procedure spSelectProduto;

delimiter $$
create procedure spSelectProduto(vcodigobarras decimal(14,0))
begin
	select * from tbproduto where ;
end $$
*/

call spSelectProduto();

-- Fim 15

-- Ex 16


create table tbprodutohistorico like tbproduto;

select * from tbprodutohistorico;
select * from tbproduto;

/*
delete from tbprodutohistorico where codbarras = 6;
alter table tbprodutohistorico modify codbarras int not null;
alter table tbprodutohistorico drop primary key;
alter table tbprodutohistorico modify funcid int null;
*/

-- Fim 16

-- Ex 17

alter table tbprodutohistorico add atualizacao datetime;
alter table tbprodutohistorico add ocorrencia varchar(20);

-- Fim 17

-- Ex 18

alter table tbprodutohistorico drop primary key;
alter table tbprodutohistorico modify codbarras decimal(14,0) not null;
alter table tbprodutohistorico add constraint pk_id_produtohistorico primary key (codbarras, ocorrencia, atualizacao);
select * from tbprodutohistorico;

-- Fim 18

-- Ex 19

delimiter $$
create trigger trgInsertProduto after Insert on tbproduto
	for each row
    begin
    insert into tbprodutohistorico
		set codbarras = new.codbarras,
        qtd = new.qtd,
        nome = new.nome,
		valorunitario = new.valorunitario,
        atualizacao = current_timestamp(),
        ocorrencia = "Novo";
end $$

drop trigger trgInsertProduto;

select * from tbproduto;
select * from tbprodutohistorico;

call spInsertProduto('12345678910119', "Agua Mineral", 1.99, 500);

-- Fim 19

-- 20

delimiter $$
create trigger trgUpdateProduto before Update on tbproduto
	for each row
    begin
    insert into tbprodutohistorico
		set codbarras = new.codbarras,
        qtd = new.qtd,
        nome = new.nome,
		valorunitario = new.valorunitario,
        atualizacao = current_timestamp(),
        ocorrencia = "Atualizado";
        
        insert into tbprodutohistorico
		set codbarras = old.codbarras,
        qtd = old.qtd,
        nome = old.nome,
		valorunitario = old.valorunitario,
        atualizacao = current_timestamp(),
        ocorrencia = "Antigo";
end $$

drop trigger trgUpdateProduto;

call spUpdateProduto('12345678910119', "Agua Mineral", 2.99);
describe tbproduto;

select * from tbproduto;
select * from tbprodutohistorico;

call spInsertProduto('12345678919999', "Boneca Beatriz", 00.50, 100);
call spUpdateProduto('12345678919999', "Boneca Beatriz de Plastico", 21.00);

-- Fim 20

-- 21

call spSelectProduto();

-- Fim 21

-- 22

select * from tbcliente;
select * from tbproduto;
select * from tbvenda;
call spInsertVenda(4,"Disney Chaplin","26-09-2022",12345678910111,65.00,1,65.00,null);

-- Fim 22

-- 23

select numerovenda, datavenda, totalvenda, notafiscal, idcliente
from tbvenda
order by numerovenda desc limit 1;

-- Fim 23

-- 24

select numerovenda, codbarras, qtd, valoritem
from tbitemvenda
order by numerovenda desc limit 1;

select * from tbitemvenda;

-- Fim 24

-- 25

delimiter $$
create procedure spShowCliente(vnomecli varchar(50))
begin
	select * from tbcliente where nomecli = vnomecli;
end $$

call spShowCliente("Disney Chaplin");

-- Fim 25

-- 26

delimiter $$
create trigger trgUpdateQtd after Insert on tbitemvenda
	for each row
		begin
		update tbproduto set qtd = qtd - new.qtd where codbarras = new.codbarras;
end $$

drop trigger trgUpdateQtd;
-- Fim 26

-- 27


select * from tbproduto where codbarras = 12345678910114;

call spInsertVenda(1,"Paganada","22-09-2022",12345678910114,10.00,15,150.00,null);
delete from tbitemvenda where codbarras = 12345678910114;

-- Fim 27

-- 28

call spSelectProduto();

-- Fim 28

-- 29

delimiter $$
create trigger trgUpdateCompraQtd after Insert on tbitemcompra
	for each row
		begin
		update tbproduto set qtd = qtd + new.qtd where codbarras = new.codbarras;
end $$
-- Fim 29

-- 30

call spInsertCompra(10548,"Amoroso e Doce",'2022-09-10',12345678910111,40.00,100,100, 4000.00);
select * from tbcompra;
select * from tbitemcompra;
select * from tbproduto where codbarras = 12345678910111;

-- Fim 30

-- 31

call spSelectProduto();

-- Fim 31