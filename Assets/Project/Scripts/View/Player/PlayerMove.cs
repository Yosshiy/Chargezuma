using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;
using UnityEngine.AI;

public class PlayerMove : MonoBehaviour
{
    Rigidbody Rigid;
    NavMeshAgent Agent;
    Vector3 a;
    [SerializeField] GameObject player;

    private void Awake()
    {
        Rigid = GetComponent<Rigidbody>();
        Agent = GetComponent<NavMeshAgent>();

        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.V))
                  .Subscribe(x =>
                  {
                      a = transform.position;
                      player.SetActive(true);
                  });
    }

    public void Move(Vector3 pos)
    {
        //pos.y = Rigid.velocity.y;
        //Rigid.velocity = pos;
        Agent.Move(pos * Time.deltaTime * 2);
    }

    void Update()
    {
        var aa = transform.position - a;
        player.transform.position = a - aa;
    }
}
