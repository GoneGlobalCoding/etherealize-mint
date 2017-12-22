import React, {Component} from 'react';
import { Link } from 'react-router-dom';
import Web3 from 'web3'
import config from '../config'

import {Card, CardActions, CardHeader, CardMedia, CardTitle, CardText} from 'material-ui/Card';
import FlatButton from 'material-ui/FlatButton';
import List, { ListItem, ListItemText } from 'material-ui/List';
import Divider from 'material-ui/Divider';
import Table, { TableBody, TableCell, TableHead, TableRow } from 'material-ui/Table';
import Paper from 'material-ui/Paper';

import Moment from 'moment'

import FunctionCard from './FunctionCard'

class Contract extends Component {
  constructor (props) {
    super(props);
    this.web3 = this.initProvider(this.props.web3provider)
    this.state = {
      contract : null,
      latestBlock : null,
      currentBlockNumber : null,
      currentBlockUpdate : null,
      networkName : this.props.network,
      contractAddress :  this.props.liveAddress,
      contractABI: this.props.abi,
      contractFunctions: null
    };
    this.initProvider = this.initProvider.bind(this)
  }
  initProvider(web3provider){
    const web3 = new Web3(new Web3.providers.HttpProvider(web3provider))
    return web3
  }
  getContract(){
    const abi = this.state.contractABI
    const address = this.state.contractAddress
    const contract = new this.web3.eth.Contract(abi,address)
    this.setState({contract: contract})
    this.getContractFunctions(contract)
    return contract
  }
  getContractFunctions(contract){
    console.log(contract)
    let functions = [];
    Object.keys(contract.methods).map(function (key) {
        if(!key.includes("0x") && key.includes("(") && key.includes(")")){
            functions.push(key)
            console.log(key)
        }
    })
    this.setState({contractFunctions: functions})
  }
  getLatestBlock(){
    const recentBlock = this.web3.eth.getBlock('latest')
    .then((block)=>{
      this.setState({latestBlock: block})
      console.log(block)
    })
    .catch((error)=>{
      console.log(error)
    })
  }
  getCurrentBlockNumber(){
    this.web3.eth.getBlockNumber(
      function(error,number){
        if(error == null){
          console.log("No error and " + number)
          Moment.locale('en');
          let dt = Date.now()
          let currentTime = Moment(dt).format('LLLL HH:mm:ss')
          this.setState({ currentBlockNumber: number,
                          currentBlockUpdate: currentTime})
        } else {
          console.log(error)
        }
      }.bind(this)
    )
  }
  componentDidMount(){
    this.getContract()
    this.getLatestBlock()
    this.getCurrentBlockNumber()   
    setInterval(() => this.getCurrentBlockNumber(), 20000);
  }
  render () {
    const { contract, latestBlock, currentBlockNumber,
            networkName, contractAddress, currentBlockUpdate,
            contractFunctions } = this.state;

    return (
      <div>
         <FunctionCard 
            header="EtherealizeCrowdsale Contract"
            sub={
                     <div>
                     <p>Using Ethereum Network: <strong>{networkName}</strong></p>
                     <span>Contract Address: </span><a href={`http://ropsten.etherscan.io/address/${contractAddress}#code`} target="_blank">{contractAddress}</a>
                     </div>}
            avatar={require("../static/img/avatar.jpg")}
            textTitle="Current block" 
            textSub="web3.eth.getBlock('latest')" 
            text={
              <div style={{"height" : "60px"}}>
                    <span style={{"display":"block","color":"grey","float":"left","clear":"both"}}>
                    web3.eth.getBlockNumber().then(function(error,number)). Set interval: 20 seconds
                    </span>
                    <span style={{"display":"block","float":"left","clear":"left","marginRight":"15px"}}>
                    BlockNumber:
                    </span> 
                    <span style={{"display":"block","color":"blue", "float":"left"}}>
                    {this.state.currentBlockNumber}
                    </span>
                    <span style={{"display":"block","color":"grey", "clear": "both","float":"left"}}>
                    Last updated at {this.state.currentBlockUpdate}
                    </span>
                </div>
            }
         />
          {
            contractFunctions != null ? contractFunctions.map(function(functionName) { 
              console.log(contract)
              return <FunctionCard   
                header = {functionName}
                sub = {functionName}
                avatar = {functionName}
                textTitle = {functionName}
                text= {functionName}
                textSub = {functionName}
                overlayTitle = {functionName}
                functionName = {functionName}
                contract = {contract}
              />
             }) : null
          }
        </div>
    )
  }
}

export default Contract;