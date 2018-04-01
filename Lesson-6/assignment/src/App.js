import React, { Component } from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
import getWeb3 from './utils/getWeb3'

import { Layout, Menu, Spin, Alert } from 'antd';

//import Common from "./components/Common";
//import Accounts from "./components/Accounts";
import Employer from "./components/Employer";
import Employee from "./components/Employee";

// import './css/oswald.css'
// import './css/open-sans.css'
// import './css/pure-min.css'
import 'antd/dist/antd.css';
import './App.css'

const { Header, Content, Footer } = Layout;

class App extends Component {
  constructor(props) {
    super(props)
    this.state = {
      web3: null,
      mode: 'employer'
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.
    getWeb3.then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    const contract = require('truffle-contract')
    const payroll = contract(PayrollContract)
    payroll.setProvider(this.state.web3.currentProvider)

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      console.log(accounts);
      this.setState({
        account:accounts && accounts[0]
      });

      payroll.deployed().then((instance) => {
        this.setState({
          payroll:instance
        });
      });

    })
  }

  // onSelectAccount=(employee)=>{
  //
  //   this.setState({
  //     selectedAccount:employee.target.text
  //   });
  //
  // }

  onSelectTab = ({key}) => {
    this.setState({
      mode: key
    });
  }

  renderContent = () => {
    const {account, payroll, web3, mode } = this.state;
    if(!payroll) {
      return <Spin tip="Loading..." />
    }

    switch (mode) {
      case 'employee':
        return <Employee employee={account} payroll={payroll} web3={web3} />
      case 'employer':
        return <Employer account={account} payroll={payroll} web3={web3} />
      case 'about':
          return <Alert message="欢迎使用Ted开发的以太坊薪酬管理系统" type="info"/>
      default:
        return <Alert message="请选择一个模式" type="info" showIcon />
    }

  }

  render() {
    //console.log('call render');
    //console.log(this.state);
    // const {selectedAccount,accounts,payroll,web3}=this.state;
    //
    // if(!accounts){
    //   return <div>Loading</div>;
    // }

    return (
      <Layout>
        <Header className='header'>
          <div className='logo'>Ted区块链开发</div>
          <Menu
            theme="dark"
            mode="horizontal"
            defaultSelectedKeys={['employer']}
            style={{lineHeight:'64px'}}
            onSelect={this.onSelectTab}
            >
            <Menu.Item key="employer">雇主</Menu.Item>
            <Menu.Item key="employee">雇员</Menu.Item>
            <Menu.Item key="about">关于</Menu.Item>
          </Menu>
        </Header>
        <Content style={{padding:'0 50px'}}>
          <Layout style={{ padding:'24px 0', background:'#fff', minHeight: '600px'}}>
            {this.renderContent()}
          </Layout>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          Payroll ©2018 TedXiong xiong-wei@hotmail.com
        </Footer>
      </Layout>
    );
  }
}

export default App
