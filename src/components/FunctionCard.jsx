import React, {Component} from 'react'

/** Material UI Components */
import {Card, CardActions, CardHeader, CardMedia, CardTitle, CardText} from 'material-ui/Card';
import FlatButton from 'material-ui/FlatButton';
import List, { ListItem, ListItemText } from 'material-ui/List';
import Divider from 'material-ui/Divider';
import Table, { TableBody, TableCell, TableHead, TableRow } from 'material-ui/Table';
import Paper from 'material-ui/Paper';

class FunctionCard extends Component {
    constructor(props){
        super(props)
        this.state = {
            cardHeader : this.props.header,
            cardSub: this.props.sub,
            avatar: this.props.avatar,
            overlayTitle: this.props.overlayTitle,
            textTitle : this.props.textTitle,
            text: this.props.text,
            textSub: this.props.textSub,
            actions: this.props.actions,
            functionName: this.props.functionName,
            contract: this.props.contract
        }
    }
    executeWeb3Call(contract,functionName){
        // var testFunction = `contract.methods.${functionName}.call()`
        // console.log("executeWeb3Call")
        // console.log(testFunction);
        // var fn = window[testFunction];
        // console.log(fn)
        // var fnparams = [
        //     {from: '0xe47c4befb25055860fd026e96885b30c7a244b30'}, 
        //     function(error, result){
        //         console.log(error);
        //         console.log(result);
        //     }];
        if(typeof(contract !== "undefined")){
            console.log(contract)
            contract.methods.rate().call({from: '0xe47c4befb25055860fd026e96885b30c7a244b30'}, 
            function(error, result){
                console.log(error);
                console.log(result);
            })

        }
                // console.log(fnparams)
        // if (typeof fn === "function"){
            
        //     console.log("fn isssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss a function")
        //     // test = fn()();
        //     test = fn.call.apply(null, fnparams)
        //     console.log(test)
        //     // fn.apply(null, fnparams);
        // } else {
        //     console.log("not a function")
        // }
    }
    render() {
        const { cardHeader, cardSub, avatar, actions,
                textTitle, text, textSub, overlayTitle } = this.state;
        const cardStyle = {
            maxWidth: 600,
            margin: "0 auto",
            marginBottom: "29px"
        };
        return(
            <Card style={cardStyle}>
                <CardHeader
                title={<h1 style={{margin: 0}}>{this.props.header}</h1>}
                subtitle={this.props.sub}
                avatar={this.props.avatar}
                />
                <CardMedia
                    overlay={
                    <CardTitle 
                        title={this.props.overlayTitle}/>
                    }>
                <img src={require("../static/img/test.jpg")} alt="" />
                </CardMedia>
                <CardTitle title={this.props.textTitle} subtitle={this.props.textSub}/>
                <CardText>
                    {this.props.text}
                    {this.executeWeb3Call(this.props.contract,this.props.functionName)}
                </CardText>
                <CardActions>
                   { this.props.actions }
                </CardActions>
            </Card>
        )
    }
}

export default FunctionCard



// <Card style={card}>
//                 <CardHeader
//                 title={<h1 style={{margin: 0}}>EtherealizeCrowdsale Contract</h1>}
//                 subtitle={
//                     <div>
//                     <p>Using Ethereum Network: <strong>{networkName}</strong></p>
//                     <span>Contract Address: </span><a href={`http://ropsten.etherscan.io/address/${crowdsaleAddress}#code`} target="_blank">{crowdsaleAddress}</a>
//                     </div>}
//                 avatar={require("../static/img/avatar.jpg")}
//                 />
//                 <CardMedia
//                     overlay={
//                     <CardTitle 
//                         title={`EtherealizeCrowdsale Contract`}/>
//                     }>
//                 <img src={require("../static/img/test.jpg")} alt="" />
//                 </CardMedia>
//                 <CardTitle title="Web3 Interactions" subtitle="web3.eth.functions" />
//                 <CardText>
//                 <div style={{"height" : "60px"}}>
//                     <span style={{"display":"block","color":"grey","float":"left","clear":"both"}}>
//                     web3.eth.getBlockNumber().then(function(error,number)). Set interval: 20 seconds
//                     </span>
//                     <span style={{"display":"block","float":"left","clear":"left","marginRight":"15px"}}>
//                     BlockNumber:
//                     </span> 
//                     <span style={{"display":"block","color":"blue", "float":"left"}}>
//                     {currentBlockNumber}
//                     </span>
//                     <span style={{"display":"block","color":"grey", "clear": "both","float":"left"}}>
//                     Last updated at {currentBlockUpdate}
//                     </span>
//                 </div>
//                 </CardText>
//                 <CardActions>
//                 <FlatButton label="Action1" />
//                 <FlatButton label="Action2" />
//                 </CardActions>
//             </Card>