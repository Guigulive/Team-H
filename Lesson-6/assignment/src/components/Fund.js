import React, { Component } from 'react'
import { Form, InputNumber, Button } from 'antd';

import Common from './Common';

const FormItem = Form.Item;

class Fund extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  componentDidMount() {
    const { payroll } = this.props;
    const refreshInfo = (error, result) => {
      if (!error) {
        this.setState({
          fund: ''
        });
      }
    }

    this.addFundEvent = payroll.AddFund(refreshInfo);
  }

  componentWillUnmount() {
    this.addFundEvent.stopWatching();
  }

  handleSubmit = (ev) => {
    ev.preventDefault();
    this.addFund();
    //alert("增加资金成功");
  }

  render() {
    const { account, payroll, web3 } = this.props;
    return (
      <div>
        <Common account={account} payroll={payroll} web3={web3} />

        <Form layout="inline" onSubmit={this.handleSubmit}>
          <FormItem>
            <InputNumber
              value={this.state.fund}
              min={1}
              onChange={fund=>this.setState({fund})}
            />
          </FormItem>
          <FormItem>
            <Button
              type="primary"
              htmlType="submit"
              disabled={!this.state.fund}>
              增加资金
            </Button>
          </FormItem>
        </Form>
      </div>
    );
  }

  addFund = () => {
      const { payroll, account, web3 } = this.props;
      payroll.addFund({
          from: account,
          //default input unit is ether
          value: web3.toWei(this.state.fund)
      });
      //console.log('addFund success!');
  }
}

export default Fund
